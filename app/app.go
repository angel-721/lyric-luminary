package main

import (
	"context"
	"fmt"
	"os/exec"
)

// App struct
type App struct {
    ctx context.Context
}

// NewApp creates a new App application struct
func NewApp() *App {
    return &App{}
}

// startup is called when the app starts. The context is saved
// so we can call the runtime methods
func (a *App) startup(ctx context.Context) {
    a.ctx = ctx
}

// Greet returns a greeting for the given name
func (a *App) Greet(name string) string {
    return fmt.Sprintf("Hello %s, It's show time!", name)
}


func (a *App) Predict(songLyrics string) string {
		pythonScriptPath := "./call_model.py"
		pythonModelPath := "./model.pkl"
    Pythoncmd := exec.Command(pythonScriptPath, "--song-lyrics", songLyrics, "--model-name", pythonModelPath)

    pythonout, err := Pythoncmd.Output()
    if err != nil {
				fmt.Print(err.Error())
        panic(err)
    }
    return string(pythonout)
}
