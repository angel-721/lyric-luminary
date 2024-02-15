/*
 * PLEASE RUN THIS SERVER FROM THE MAIN DIR OR YOU'RE NOT GOING TO BE HAPPY
 *
 */

const express = require("express");

const app = express();
const spawn = require("child_process").spawn;

app.use(express.urlencoded({ extended: true }));

app.post("/lyrics", function (request, response) {
	console.log("/POST for /lyrics");

	const song = request.body;
	let lyrics = song.lyrics;
	let input = '"';
	input += lyrics;
	input += '"';
	console.log(input);
	var process = spawn("python", ["./main.py", "predict", "-s" + input ]);

	process.stdout.on("data", (data) => {
		let output = data.toString("utf8");
		response.setHeader("Access-Control-Allow-Origin", "*");
		response.status(201).send("Predicted lablel: " + output);
	});

	process.stderr.on("data", (data) => {
		console.log(data.toString("utf8"));
		response.status(404).send("Failed to Create");
	});
});

app.listen(8080, function () {
	console.log("Server is running on http://localhost:8080");
});
