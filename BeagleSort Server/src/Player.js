const ArrayState = require('./ArrayState');

class Player {
  constructor(socket, name) {
    this.socket = socket;
    this.name = name;
    this.arrState = null;
    this.stateIndex = 1;
    this.game = null;

    const self = this;
    this.socket.on('player_move', function(fromIndex, toIndex) {
      self.game.playerMove(self, fromIndex, toIndex);
    });
  }
}

module.exports = Player;
