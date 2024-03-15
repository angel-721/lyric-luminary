<script>
  import {Predict} from '../wailsjs/go/main/App.js'
  import {GetSpotifyRecommendations} from '../wailsjs/go/main/App.js'
	import '@picocss/pico'


	let predictedGenre = ""
	let songLyrics = ""
	let recommendations = []


	// States
	let isPredicting = false

	async function predict(){
		isPredicting = true
		if(songLyrics == ""){
			alert("Please input a song!")
			isPredicting = false
			return
		}

		Predict(songLyrics).then(result => {
			if(result == "rap")
				predictedGenre = "hip-hop"
			else
				predictedGenre = result
		})
		isPredicting = false
	}

	async function fetchRecommendations(){
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

<main class="container">

	<h1 class="centered-text">Music Genre Classifier</h1>

	<div class="centered-div">
		<textarea bind:value={songLyrics} placeholder="Enter Song Lyrics Here"
		rows="15" id="lyric-text-area" />
	</div>

	{#if isPredicting}
    <button aria-busy="true" aria-label="Please wait…">Predicting...</button>
  {:else}
    <button on:click={predict}>Predict!</button>
  {/if}

	<button on:click={fetchRecommendations}>Get Spotify Recommendations</button>
	<p>{predictedGenre}</p>

	<h2>Recommendations</h2>
	{#each recommendations as song}
		<div>
			<p>{song.track_name} by {song.artist_name}</p>
			<img src={song.image_link} alt="">
		</div>
	{/each}
</main>

<input type="checkbox" role="switch" />

<style>
.centered-text{
	text-align: center;
}

#lyric-text-area{
	height: 100%;
	width: 70%;
	text-align: center;
}

</style>
