<?php
	
	// get image, wav
	$image = $_POST["image"];
	$wav_Str = $_POST["wav_Str"];
	$title = $_POST["title"];

	// replace spaces with +
	$data = str_replace(" ", "+", $image);
	$wav_data = str_replace(" ", "+", $wav_Str);
	$title_data = str_replace(" ", "+", $title);

	// decoding base 64
	$data = base64_decode($data);
	$wav_data = base64_decode($wav_data);
	$title_data = base64_decode($title_data);

	// saving in file as image
	file_put_contents("image.jpg", $data);
	file_put_contents("/Users/seungwoomun/Documents/MYC/code/wav/title.wav", $wav_data);

	// run python script
	exec("cd /Users/seungwoomun/Documents/MYC/code/ && python3 use_Model.py");
	// $command = escapeshellcmd("cd /Users/seungwoomun/Documents/MYC/code/ && python3 use_Model.py");
	// shell_exec($command.print_pdf("$title_data.wav"));
	
	// $command = escapeshellcmd('/Users/seungwoomun/Documents/MYC/code/use_Model.py');
	// $output = shell_exec($command);
	// echo $output;

	// $pdf->setSourceFile('./airplane_1.pdf');
	// pdf 파일 이름 수정
	rename("/Users/seungwoomun/Documents/MYC/code/pdf/title.pdf", "/Users/seungwoomun/Documents/MYC/code/pdf/$title_data.pdf");
	rename("/Users/seungwoomun/Documents/MYC/code/pdf/title.xml", "/Users/seungwoomun/Documents/MYC/code/pdf/$title_data.xml");
	rename("/Users/seungwoomun/Documents/MYC/code/midi/title.mid", "/Users/seungwoomun/Documents/MYC/code/midi/$title_data.mid");
	rename("/Users/seungwoomun/Documents/MYC/code/wav/title.wav", "/Users/seungwoomun/Documents/MYC/code/wav/$title_data.wav");

	// sending response back
	echo "$title_data 변환 완료";

	// var express = require('express'); require('dotenv').config(); 
	// var cors = require('cors'); 
	// var mysql = require('mysql'); 
	// var bodyParser = require('body-parser'); 
	// var http = require('http'); 
	// var app = express();

	// app.use(bodyParser.urlencoded({ extended: true })); 
	// app.use(bodyParser.json()); 
	// app.use(bodyParser.raw({ type: 'audio/m4a', limit: '60mb' })) app.use(cors());

	// app.post('/addAudio', function (req, res) { 
	// 	console.log("Audio is successfully posted!"); 
	// 	console.log("Obtained audio data: ", req.body); 
	// });

	// app.listen(8080, function () { 
	// 	console.log("Server is listening on port 8080!");
	// });
?>

