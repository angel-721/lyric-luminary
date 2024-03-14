<script>
  import {Greet} from '../wailsjs/go/main/App.js'
  import {Predict} from '../wailsjs/go/main/App.js'

	let predictText = ""
	let songLyrics = ""

	function predict(){
		if(songLyrics == ""){
			alert("Please input a song!")
			return

		}

		Predict(songLyrics).then(result => predictText = result)
	}

</script>
<main>
	<h1>Hi</h1>
	<textarea bind:value={songLyrics} placeholder="Enter Song Lyrics Here"
	rows="30" cols="30"/>
	<button on:click={predict}>Predict!</button>
	<p>{predictText}</p>
</main>

<style>

</style>
