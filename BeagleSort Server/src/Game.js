const BubbleSort = require('./algorithms/BubbleSort');
const ArrayState = require('./ArrayState');

class Game {
  constructor(player1, player2) {
    this.player1 = player1;
    this.player2 = player2;

    // generate array
    const arr = [];
    for (let i = 0; i < 7; i++) {
      arr.push(Math.floor(Math.random() * 10));
    }
    this.arr = arr;

    // generate algorithm
    this.algorithm = 'BubbleSort';

    // generate states
    switch (this.algorithm) {
      case 'BubbleSort':
        this.states = BubbleSort.generateArrayStates(arr);
        break;
    }

    // set player states
    this.player1.arrState = new ArrayState([0, 1, 2, 3, 4, 5, 6]);
    this.player2.arrState = new ArrayState([0, 1, 2, 3, 4, 5, 6]);
  }
}

Game.prototype.playerMove = function(player, fromIndex, toIndex) {
  // swap state
  const temp = player.arrState.arr[fromIndex];
  player.arrState.arr[fromIndex] = player.arrState.arr[toIndex];
  player.arrState.arr[toIndex] = temp;

  // verify state
  let res = 'Incorrecto';
  if (player.arrState.compareWith(this.states[player.stateIndex])) {
    res = 'Correcto';
    player.stateIndex++;
  }

  // send to player
  player.socket.emit('player_move_response', {res});

  if (player === this.player1) {
    this.player2.socket.emit('other_player_move', {fromIndex, toIndex});
  } else {
    this.player1.socket.emit('other_player_move', {fromIndex, toIndex});
  }
};

module.exports = Game;
