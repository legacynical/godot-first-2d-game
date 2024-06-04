using Godot;
using System;

public partial class playerCSharp : Area2D
{
	[Signal]
	public delegate void HitEventHandler();

	[Export]
	public int Speed { get; set; } = 400; // player move speed (pixels/sec)

	public Vector2 ScreenSize; //size of game window

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ScreenSize = GetViewportRect().Size;
		Hide();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		var velocity = Vector2.Zero; // player movement vector (direction)

		if (Input.IsActionPressed("move_right"))
		{
			velocity.X += 1;
		}
		
		if (Input.IsActionPressed("move_left"))
		{
			velocity.X -= 1;
		}
		
		if (Input.IsActionPressed("move_down"))
		{
			velocity.Y += 1;
		}
		
		if (Input.IsActionPressed("move_up"))
		{
			velocity.Y -= 1;
		}

		var animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

		if (velocity.Length() > 0)
		{
			velocity = velocity.Normalized() * Speed;
			animatedSprite2D.Play();
		}
		else
		{
			animatedSprite2D.Stop();
		}

		Position += velocity * (float)delta; // update player position
		Position = new Vector2( // prevent inconsistent diagonal speed
			x: Mathf.Clamp(Position.X, 0, ScreenSize.X),
			y: Mathf.Clamp(Position.Y, 0, ScreenSize.Y)
		);

		if (velocity.X != 0) // if moving left or right
		{
			animatedSprite2D.Animation = "walk";
			animatedSprite2D.FlipV = false; // ensure no vert flip
			animatedSprite2D.FlipH = velocity.X < 0; // sprite (facing right) flips when moving left
		}
		else if (velocity.Y != 0) // if moving up or down without left/right movement
		{
			animatedSprite2D.Animation = "up";
			animatedSprite2D.FlipV = velocity.Y > 0;
		}
	}

	private void OnBodyEntered(Node2D body)
	{
		Hide(); // player disappears after being hit
		EmitSignal(SignalName.Hit);
		GetNode<CollisionShape2D>("CollisionShape2D").SetDeferred(CollisionShape2D.PropertyName.Disabled, true);
	}

	public void Start(Vector2 position)
	{
		Position = position;
		Show();
		GetNode<CollisionShape2D>("CollisionShape2D").Disabled = false;
	}
}
