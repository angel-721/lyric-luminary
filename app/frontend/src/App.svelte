<script>
  import { Predict } from "../wailsjs/go/main/App.js";
  import { GetSpotifyRecommendations } from "../wailsjs/go/main/App.js";
  import { GetGeniusLyrics } from "../wailsjs/go/main/App.js";
  import "@picocss/pico";
  import { BrowserOpenURL } from "../wailsjs/runtime/runtime.js";
  import "./style.css";
  import predictbulb from "./assets/images/predictbulb.svg";
  import darkbulb from "./assets/images/darkbulb.svg";
  import spotifylogo from "./assets/images/spotify.svg";

  let predictedGenre = "";
  let songLyrics = "";
  let recommendations = [];
  let songLink = "";
  let lyricRows = 1;
  $: recommendations = recommendations;

  let currentSong = null;

  // States
  let isPredicting = false;
  let isRecommending = false;
  let hasPredicted = false;
  let hasRecommended = false;
  let isLinkMode = false;

  $: {
    isPredicting;
    console.log("isPredicting changed:", isPredicting);
  }

  function predict() {
    isPredicting = true;
    if (songLyrics == "" && !isLinkMode) {
      alert("Please input a song!");
      isPredicting = false;
      return;
    }

    if (songLink == "" && isLinkMode) {
      alert("Please input a song!");
      isPredicting = false;
      return;
    }

    if (isLinkMode) {
      getSongLyrics(songLink).then((result) => {
        console.log("Result:", result);
        songLyrics = result;
        Predict(songLyrics).then((genre) => {
          predictedGenre = genre;
          isPredicting = false;
          hasPredicted = true;
          isLinkMode = false;
        });
      });
    } else {
      Predict(songLyrics).then((result) => {
        predictedGenre = result;
        isPredicting = false;
        hasPredicted = true;
      });
    }
  }

  function handleInput(event) {
    const textarea = event.target;
    const maxRows = 12; // Set the maximum number of rows

    textarea.style.height = "auto";
    textarea.style.height = `${textarea.scrollHeight}px`;

    // Calculate the number of rows based on the scroll height
    const rows = Math.floor(
      textarea.scrollHeight / parseFloat(getComputedStyle(textarea).lineHeight)
    );

    // Limit the number of rows to the maximum allowed
    lyricRows = rows;
    if (rows > maxRows) {
      textarea.style.overflowY = "scroll";
      textarea.style.height = `${maxRows * parseFloat(getComputedStyle(textarea).lineHeight)}px`;
    } else {
      textarea.style.overflowY = "hidden";
    }
  }

  function changeMode() {
    songLink = "";
    songLyrics = "";
    isLinkMode = !isLinkMode;
  }

  function openLink(trackUrl) {
    BrowserOpenURL(trackUrl);
  }

  function fetchRecommendations() {
    isRecommending = true;
    if (
      predictedGenre == "" ||
      predictedGenre == "Invalid" ||
      hasPredicted == false
    ) {
      alert(
        "Please predict before getting recommendations based off prediction!"
      );
      isRecommending = false;
      return;
    }

    GetSpotifyRecommendations(predictedGenre).then((result) => {
      const recommendedTracks = JSON.parse(result);
      recommendations = recommendedTracks;
      isRecommending = false;
      hasRecommended = true;
    });
  }
  function resetPrediction() {
    lyricRows = 1;
    hasPredicted = false;
    songLyrics = "";
    songLink = "";
    recommendations = [];
    hasRecommended = false;
  }

  function playPreview(songUrl) {
    if (currentSong == null) {
      currentSong = new Audio(songUrl);
    } else if (currentSong != null && currentSong.src != songUrl) {
      currentSong.pause();
      currentSong.currentTime = 0;
      currentSong.src = songUrl;
    } else if (currentSong != null && currentSong.src == songUrl) {
      currentSong.pause();
      currentSong.currentTime = 0;
      return;
    }
    currentSong.play();
  }

  async function getSongLyrics(songUrl) {
    let lyrics = "";
    try {
      lyrics = await GetGeniusLyrics(songUrl);
    } catch (error) {
      console.error("Error getting lyrics:", error);
    }
    return lyrics;
  }
</script>

<main class="container">
  <h1>Lyric Luminary</h1>

  {#if hasPredicted}
    <div id="img-div" class="centered-div">
      <img
        id="predictbulb"
        class:fade-in={hasPredicted}
        src={predictbulb}
        alt="blub"
      />
    </div>
    <p class="prediction-text">
      And the predicted genre is <strong class="genre-reveal"
        >{predictedGenre}</strong
      >!
    </p>
  {:else}
    <div id="img-div" class="centered-div">
      <img
        id="predictbulb"
        class:fade-out={hasPredicted}
        class:tilt={isPredicting}
        src={darkbulb}
        alt="blub"
      />
    </div>
    {#if isPredicting}
      <p class="prediction-text">And the predicted genre is ...</p>{/if}
  {/if}

  {#if !isLinkMode}
    <div class="centered-div">
      <textarea
        bind:value={songLyrics}
        placeholder="Enter Song Lyrics Here"
        rows={lyricRows}
        id="lyric-text-area"
        on:input={handleInput}
        style="height: auto; overflow-y: hidden;"
        disabled={hasPredicted}
      />
    </div>
  {:else}
    <div class="centered-div">
      <textarea
        bind:value={songLink}
        placeholder="Enter Genius Link Here"
        rows="1"
        id="lyric-text-area"
        on:input={handleInput}
        style="height: auto; overflow-y: hidden;"
        disabled={hasPredicted}
      />
    </div>
  {/if}

  {#if !hasPredicted}
    <div id="button-div" class="centered-div">
      <button on:click={predict} disabled={isPredicting} class="yellow-button">
        {#if isPredicting}Predicting...{:else}Predict{/if}
      </button>
      {#if isLinkMode}
        <button on:click={changeMode} disabled={isPredicting} class="other-button">
          {#if isPredicting}Predicting...{:else}Switch to Manual Lyric Input{/if}
        </button>
      {:else}
        <button on:click={changeMode} disabled={isPredicting} class="yellow-button">
          {#if isPredicting}Predicting...{:else}Switch to Genius Link Input{/if}
        </button>
      {/if}
    </div>
  {/if}

  {#if hasPredicted}
    <div id="button-div" class="centered-div">
      {#if isRecommending}
        <button class="spotify" aria-busy="true" aria-label="Please wait…"
          >Recommending...</button
        >
      {:else}
        <button class="spotify" on:click={fetchRecommendations}
          >Get Spotify Recommendations</button
        >
      {/if}
      <div class="centered-div">
        <button class="yellow-button" on:click={resetPrediction}>Predict on a New Song</button>
      </div>
    </div>
    <div id="predict-area" class="centered-div"></div>
  {/if}

  {#if hasRecommended && hasPredicted}
    <div id="recs">
      <h2 style="text-align: center;">Recommendations</h2>
    </div>

    <table class="song-table">
      <thead>
        <th>
          <div class="song-title-top-div">Title</div>
        </th>
        <th>
          <div class="song-artist-top-div">Album</div>
        </th>
        <th>
          <div class="song-length-top-div">Length</div>
        </th>
      </thead>

      <tbody data-theme="dark">
        {#each recommendations as song}
          <tr class="song-tr">
            <td>
              <div class="song-name-div">
                <div class="song-image-container">
                  <!-- svelte-ignore a11y-img-redundant-alt -->
                  <img
                    class="song-image"
                    src={song.image_link}
                    alt="song image"
                  />
                  <!-- svelte-ignore a11y-click-events-have-key-events -->
                  <div
                    class="play-overlay"
                    on:click={() => playPreview(song.preview_link)}
                  >
                    <i class="fas fa-play"></i>
                  </div>
                </div>
                <div class="vertical-center">
                  <div class="song-text-container">
                    <div class="song-text-div song-name">
                      {song.track_name}
                    </div>
                    <div class="song-text-div artist-name">
                      {song.artist_name}
                    </div>
                  </div>
                </div>
              </div>
            </td>
            <td>
              <div class="song-name-div">
                <div class="song-album-div">{song.album_name}</div>
              </div>
            </td>
            <td>
              <div class="vertical-center">
                <div class="song-duration-div">{song.duration_ms}</div>
                <!-- svelte-ignore a11y-click-events-have-key-events -->
                <img
                  src={spotifylogo}
                  on:click={() => openLink(song.track_link)}
                  id="spotify-logo"
                  alt="spotify logo"
                />
              </div>
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  {/if}
</main>
