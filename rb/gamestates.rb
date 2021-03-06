class Introduction < Chingu::GameState
	def initialize
		super
		puts "Introduction"
		@counter = 0
		@music = Gosu::Song.new($window, "media/music/backgroundmusic.OGG")
		@music.volume = 0.5
		@music.play(true)

		@click = Gosu::Sample.new($window, "media/sfx/keypress.OGG")

		@text = Chingu::Text.create("Welcome to ChinguRoids", :y => $window.HEIGHT/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
		@text.x = $window.WIDTH/2 - @text.width/2

		@text2 = Chingu::Text.create("Press ENTER to play", :y => $window.HEIGHT/4+$window.HEIGHT/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
		@text2.x = $window.WIDTH/2 - @text2.width/2

		@player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
		self.input = {:return => :next}
	end

	def update
		super
		@counter += 1

		if(@counter == 20)
			@random = rand(4)+1

			case @random
			when 1
				Meteor.create(x: rand($window.WIDTH)+1, y: 0,
							  velocity_y: rand(5)+1, velocity_x: rand(-5..5),
							  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			when 2
				Meteor.create(x: rand($window.WIDTH)+1, y: 600,
				 			  velocity_y: rand(1..5)*-1, velocity_x: rand(-5..5),
				  			  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			when 3
				Meteor.create(x: 0, y: rand($window.HEIGHT)+1,
							  velocity_x: rand(1..5), velocity_y: rand(-5..5),
					  		  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			when 4
				Meteor.create(x: 800, y: rand($window.HEIGHT)+1,
				 			  velocity_x: rand(1..5)*-1, velocity_y: rand(-5..5),
				 			  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			end
			@counter = 0
		end

		Meteor.destroy_if {|meteor| meteor.outside_window?}
	end

	def next
		@click.play
		@music.stop
		close
	end
end

class Level_1 < Chingu::GameState
	def initialize
		super 
		$score = 0
		@meteor_counter = 0
		#Objects
		@player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
		@player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
		@gui = GUI.create(@player)
	end

	def draw
		super
		Gosu::Image["assets/window/background.png"].draw(0, 0, 0)
	end

	def update
		super
		check_for_collision

		Bullet.destroy_if {|bullet| bullet.outside_window?}
		Meteor.destroy_if {|meteor| meteor.outside_window?}

		@meteor_counter += 1
		if(@meteor_counter == 20)
			@random = rand(4)+1
			case @random
			when 1
				Meteor.create(x: rand($window.WIDTH)+1, y: 0,
							  velocity_y: rand(5)+1, velocity_x: rand(-5..5),
							  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			when 2
				Meteor.create(x: rand($window.WIDTH)+1, y: 600,
				 			  velocity_y: rand(1..5)*-1, velocity_x: rand(-5..5),
				  			  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			when 3
				Meteor.create(x: 0, y: rand($window.HEIGHT)+1,
							  velocity_x: rand(1..5), velocity_y: rand(-5..5),
					  		  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			when 4
				Meteor.create(x: 800, y: rand($window.HEIGHT)+1,
				 			  velocity_x: rand(1..5)*-1, velocity_y: rand(-5..5),
				 			  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
			end
			@meteor_counter = 0
		end
	end

	def check_for_collision
		Bullet.each_collision(Meteor) do |projectile, meteor|
			meteor.destroy
			projectile.destroy
			$score += 5
		end
		Player.each_collision(Meteor) do |player, meteor|
			player.destroy
			@player.input = {}
			meteor.destroy
		end
	end
end