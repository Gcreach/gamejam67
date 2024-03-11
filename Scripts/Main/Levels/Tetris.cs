using Godot;
using System;

public partial class Tetris : Node2D
{

	[Export] public Label TurnLabel;
	[Export] public CompressedTexture2D Blue;
	[Export] public CompressedTexture2D Red;
	[Export] public CompressedTexture2D Yellow;

	[Export] public TileMap TileMap;

	private string turnOn = "";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		

		GD.RandRange(150, 250);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void UpdateLabels() {
		if(turnOn == "blue") {
			TurnLabel.Text = "Blue";
		}
		else if (turnOn == "Red") {
			TurnLabel.Text = "Red";
		 }
		 else if (turnOn == "Yellow") {
			TurnLabel.Text = "Yellow";
		  }
	}

	
}
