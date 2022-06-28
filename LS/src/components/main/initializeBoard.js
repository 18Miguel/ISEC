/**
 * Inicia um tabuleiro de letras aleatorias com as dimenções pretendidas
 * @param {height} height Altura pretendida para o tabuleiro
 * @param {width} width Largura pretendida para o tabuleiro
 */
function InitializeBoard(height, width) {
  let board = {
    letters: Array.from({ length: height }, () => Array.from({ length: width }, () => "X")),
    bin: Array.from({ length: height }, () => Array.from({ length: width }, () => 0)),
  };

  let Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  for (let i = 0; i < height; i++)
    for (let j = 0; j < width; j++) {
      let randomNumber = Math.floor(Math.random() * Alphabet.length);
      board.letters[i][j] = Alphabet.charAt(randomNumber);
    }
    
  return board;
}

export default InitializeBoard;
