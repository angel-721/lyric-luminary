package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"

	"github.com/broxgit/genius"
	"github.com/joho/godotenv"
	"github.com/zmb3/spotify/v2"
	spotifyauth "github.com/zmb3/spotify/v2/auth"
	"golang.org/x/oauth2/clientcredentials"
)

// Spotify API credentials
var ClientID string
var ClientSecret string
var GeniusToken string
var GeniusClient *genius.Client

// var GeniusClient

func formatDuration(durationMs int) string {
	duration := time.Duration(durationMs) * time.Millisecond
	minutes := int(duration.Minutes())
	seconds := int(duration.Seconds()) % 60
	return fmt.Sprintf("%d:%02d", minutes, seconds)
}

type Song struct {
	TrackName     string `json:"track_name"`
	ImageLink     string `json:"image_link"`
	ArtistName    string `json:"artist_name"`
	AlbumName     string `json:"album_name"`
	TrackDuration string `json:"duration_ms"`
	PreviewLink   string `json:"preview_link"`
	TrackLink     string `json:"track_link"`
}

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
	err := godotenv.Load()
	if err != nil {
		fmt.Print(err.Error())
		panic(err)

	}
	ClientID = os.Getenv("SPOTIFY_ID")
	ClientSecret = os.Getenv("SPOTIFY_SECRET")
	GeniusToken = os.Getenv("GENIUS_TOKEN")

	GeniusClient = genius.NewClient(nil, GeniusToken)

	fmt.Println("SpotifyClient: ", ClientID)
	fmt.Println("SpotifySecret: ", ClientSecret)
	fmt.Println("GeniusToken: ", GeniusToken)
	println("App started")
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

	output := strings.TrimSpace(string(pythonout))
	return output
}

func (a *App) GetGeniusLyrics(songUrl string) string {
	lyrics, err := GeniusClient.GetLyrics(songUrl)
	if err != nil {
		fmt.Print(err.Error())
		panic(err)
	}

	return lyrics
}

func (a *App) GetSpotifyRecommendations(songGenre string) string {

	fmt.Println("SpotifyClient: ", ClientID)
	fmt.Println("SpotifySecret: ", ClientSecret)

	ctx := context.Background()
	config := &clientcredentials.Config{
		ClientID:     ClientID,
		ClientSecret: ClientSecret,
		TokenURL:     spotifyauth.TokenURL,
	}

	token, err := config.Token(ctx)
	if err != nil {
		fmt.Print(err.Error())
		panic(err)
	}

	httpClient := spotifyauth.New().Client(ctx, token)
	client := spotify.New(httpClient)

	fmt.Print(songGenre)
	genres := []string{songGenre}

	seeds := spotify.Seeds{
		Genres: genres,
	}

	track_attributes := spotify.NewTrackAttributes()

	res, err := client.GetRecommendations(ctx, seeds, track_attributes, spotify.Country("US"), spotify.Limit(5))

	recommendedTracks := []Song{}

	fmt.Print(res.Tracks)
	for _, track := range res.Tracks {
		newSong := Song{
			TrackName:     track.Name,
			ImageLink:     track.Album.Images[0].URL,
			ArtistName:    track.Artists[0].Name,
			AlbumName:     track.Album.Name,
			TrackDuration: formatDuration(track.Duration),
			PreviewLink:   track.PreviewURL,
			TrackLink:     string(track.ExternalURLs["spotify"]),
		}
		recommendedTracks = append(recommendedTracks, newSong)

	}

	jsonData, err := json.Marshal(recommendedTracks)
	if err != nil {
		fmt.Print(err.Error())
		panic(err)

	}
	return string(jsonData)
}
