const express = require('express');
const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http);
const Player = require('./Player');
const Game = require('./Game');

const gameQueue = [];
const games = [];

io.on('connection', socket => {
  console.log(`User connected with socket ID ${socket.conn.id}`);

  socket.on('enter_game_queue', name => {
    console.log('Enter game queue packet');
    // check if someone else is in queue
    if (gameQueue.length > 0) {
      const firstPlayer = gameQueue.shift();
      const secondPlayer = new Player(socket, name);

      const game = new Game(firstPlayer, secondPlayer);
      firstPlayer.game = game;
      secondPlayer.game = game;

      firstPlayer.socket.emit('entered_game', {
        otherPlayerName: secondPlayer.name,
        algorithm: game.algorithm,
        arr: game.arr,
      });
      secondPlayer.socket.emit('entered_game', {
        otherPlayerName: firstPlayer.name,
        algorithm: game.algorithm,
        arr: game.arr,
      });

      games.push(game);
      return;
    }

    // add to queue
    gameQueue.push(new Player(socket, name));
    socket.emit('waiting_queue');
  });
});

http.listen(3000, () => {
  console.log('Listening on port 3000.');
});
