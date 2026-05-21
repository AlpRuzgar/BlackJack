struct LevelLostView:View {
    var body: some View {
        Text("Level Lost")
            .font(.headline)
        Text("You lost all your chips!")
            .font(.title)
        ButtonView(action: {
            //TODO: go back to main menu
        }, text: "Main Menu", backgroundColor: .red, textColor: .white)
    }
}
