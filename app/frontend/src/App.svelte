<script>
  import {Predict} from '../wailsjs/go/main/App.js'
  import {GetSpotifyRecommendations} from '../wailsjs/go/main/App.js'

	let predictedGenre = ""
	let songLyrics = ""
	let recommendations = []

	function predict(){
		if(songLyrics == ""){
			alert("Please input a song!")
			return
		}
		Predict(songLyrics).then(result => {
			if(result == "rap")
				predictedGenre = "hip-hop"
			else
				predictedGenre = result
		})
	}

	function fetchRecommendations(){
		if(predictedGenre == "" || predictedGenre == "Invalid"){
			alert("Please predict before getting recommendations based off prediction!")
			return
		}
		GetSpotifyRecommendations(predictedGenre).then(result => {
			const recommendedTracks = JSON.parse(result);
			recommendations = recommendedTracks
		})
	}

</script>

<main>
	<h1>Hi</h1>
	<textarea bind:value={songLyrics} placeholder="Enter Song Lyrics Here"
	rows="30" cols="30"/>
	<button on:click={predict}>Predict!</button>
	<button on:click={fetchRecommendations}>Get Spotify Recommendations</button>
	<p>{predictedGenre}</p>

	<h2>Recommendations</h2>
	{#each recommendations as song}
		<p>{song.track_name} by {song.artist_name}</p>
		<img src={song.image_link} alt="">
	{/each}

</main>

<style>

</style>
