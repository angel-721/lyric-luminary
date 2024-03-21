<script>
  import {Predict} from '../wailsjs/go/main/App.js'
  import {GetSpotifyRecommendations} from '../wailsjs/go/main/App.js'
	import '@picocss/pico'


	let predictedGenre = ""
	let songLyrics = "";
	let recommendations = [];
	$: recommendations = recommendations;

	let currentSong = null;

	// States
	let isPredicting = false;
	let isRecommending = false;
	let hasPredicted = false;
	let hasRecommended = false;

  $: {
    isPredicting;
    console.log('isPredicting changed:', isPredicting);
  }


	function predict(){
		isPredicting = true;
		if(songLyrics == ""){
			alert("Please input a song!");
			isPredicting = false;
			return;
		}

		Predict(songLyrics).then(result => {
			if(result == "rap")
				predictedGenre = "hip-hop";
			else
				predictedGenre = result;

			isPredicting = false;
			hasPredicted = true;
		})
	}

	function fetchRecommendations(){
		isRecommending = true
		if(predictedGenre == "" || predictedGenre == "Invalid" || hasPredicted == false){
			alert("Please predict before getting recommendations based off prediction!");
			isRecommending = false;
			return;
		}

		GetSpotifyRecommendations(predictedGenre).then(result => {
			const recommendedTracks = JSON.parse(result);
			recommendations = recommendedTracks;
			isRecommending = false;
			hasRecommended = true;
		})
	}

	function playPreview(songUrl){

		if(currentSong == null){
			currentSong = new Audio(songUrl)
		}
		else if(currentSong != null && currentSong.src != songUrl){
			currentSong.pause();
			currentSong.currentTime = 0;
			currentSong.src = songUrl
		}
		else if(currentSong != null && currentSong.src == songUrl){
			currentSong.pause();
			currentSong.currentTime = 0;
			return;
		}
		currentSong.play()
	}

</script>

<main class="container">

	<h1 class="centered-text">Music Genre Classifier</h1>

	<div class="centered-div">
		<textarea bind:value={songLyrics} placeholder="Enter Song Lyrics Here"
		rows="15" id="lyric-text-area" />
	</div>

	{#if isPredicting}
    <button aria-busy="true">Predicting...</button>
  {:else}
    <button on:click={predict}>Predict!</button>
  {/if}

	{#if isRecommending}
    <button aria-busy="true" aria-label="Please wait…">Recommending...</button>
  {:else}
		<button on:click={fetchRecommendations}>Get Spotify Recommendations</button>
  {/if}
	<p>{predictedGenre}</p>

	{#if hasRecommended}
	<h2>Recommendations</h2>

		<table class="song-table">
			<tr>
				<td>
					<div class="song-title-top-div">Title</div>
				</td>
				<td>
					<div class="song-artist-top-div">Album</div>
				</td>
				<td>
					<div class="song-length-top-div">Length</div>
					</td>
			</tr>
		</table>

		<div id="songs-div">
		<ul id="songs-ul">
		{#each recommendations as song}
			<li class="song-li">
				<table class="song-table">
					<tr>
						<td>
									<div class="song-name-div">
										<img src={song.image_link} alt="" on:click= {()  =>
											playPreview(song.preview_link)} class="song-image">
											<div class="song-text-container">
                  			<div class="song-text-div song-name">{song.track_name}</div>
                  			<div class="song-text-div artist-name">{song.artist_name}</div>
                			</div>
									</div>
						</td>
						<td>
							<div class="song-album-div">{song.album_name}</div>
						</td>
						<td>
							<div class="song-duration-div">{song.duration_ms}</div>
						</td>
					</tr>
				</table>
			</li>
		{/each}
				</ul>
			</div>
	{/if}


</main>

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
