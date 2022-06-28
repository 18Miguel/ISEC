function InsertWordsInBoard(board, words, boardSize){
  for (let i = 0; i < words.length; i++) {
    let positions = generatePositions(words[i], board, boardSize);

    for (let j = 0; j < words[i].length; j++) {
      board.bin[positions.line][positions.column]++;

      switch (positions.orientation) {
        case "horizontal":
          if (positions.inverted) {
            board.letters[positions.line][positions.column--] = words[i].charAt(j);
            break;
          }
          board.letters[positions.line][positions.column++] = words[i].charAt(j);
          break;
          
        case "vertical":
          if (positions.inverted) {
            board.letters[positions.line--][positions.column] = words[i].charAt(j);
            break;
          }
          board.letters[positions.line++][positions.column] = words[i].charAt(j);
          break;
        
        case "diagonal-right":
            if (positions.inverted) {
              board.letters[positions.line--][positions.column--] = words[i].charAt(j);
              break;
            }
            board.letters[positions.line++][positions.column++] = words[i].charAt(j);
            break;
          
        case "diagonal-left":
          if (positions.inverted) {
            board.letters[positions.line--][positions.column++] = words[i].charAt(j);
            break;
          }
          board.letters[positions.line++][positions.column--] = words[i].charAt(j);
          break;
        
        default: break;
      }
    }
  }
  /* %%%%%%%%%%%%%%%%% [DEBUG CHEAT] %%%%%%%%%%%%%%%%% */
  console.log("[DEBUG CHEAT] insertWordsInBoard");
  for (let linhas = 0; linhas < board.bin.length; linhas++)
    console.log(board.bin[linhas]);
  /* %%%%%%%%%%%%%%%%% [DEBUG CHEAT] %%%%%%%%%%%%%%%%% */

  for (let linhas = 0; linhas < board.bin.length; linhas++)
    for (let colunas = 0; colunas < board.bin[linhas].length; colunas++)
      board.bin[linhas][colunas] = 0;

  return board;
}

function generatePositions(word, board, boardSize) {
  let positions = {
    line: 0,
    column: 0,
    orientation: "",
    inverted: false,
  };
  const wordOrientation = [
    "horizontal",
    "vertical",
    "diagonal-right",
    "diagonal-left",
  ];

  
  let ExitFlag = false;
  do {
    ExitFlag = false;
    let lastLine, lastColumn;

    positions.line = Math.floor(Math.random() * boardSize.height);
    positions.column = Math.floor(Math.random() * boardSize.width);
    positions.inverted = Math.random() >= 0.65;
    positions.orientation = wordOrientation[Math.floor(Math.random() * wordOrientation.length)];

    switch (positions.orientation) {
      case "horizontal":
        lastLine = positions.line;

        if (!positions.inverted) {
          lastColumn = positions.column + (word.length - 1);

          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let j = positions.column, indexLetter = 0; j <= lastColumn; j++, indexLetter++)
              if (board.bin[positions.line][j] !== 0)
                if (board.letters[positions.line][j] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }
        } else {
          lastColumn = positions.column;
          positions.column += (word.length - 1);
              
          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let j = lastColumn, indexLetter = (word.length - 1); j <= positions.column; j++, indexLetter--)
              if (board.bin[positions.line][j] !== 0)
                if (board.letters[positions.line][j] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }
        }
        break;
        
      case "vertical":
        lastColumn = positions.column;

        if (!positions.inverted) {
          lastLine = positions.line + (word.length - 1);

          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let i = positions.line, indexLetter = 0; i <= lastLine; i++, indexLetter++)
              if (board.bin[i][positions.column] !== 0)
                if (board.letters[i][positions.column] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }        
        } else {
          lastLine = positions.line;
          positions.line += (word.length - 1);
              
          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let i = lastLine, indexLetter = (word.length - 1); i <= positions.line; i++, indexLetter--)
              if (board.bin[i][positions.column] !== 0)
                if (board.letters[i][positions.column] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }
        }
        break;

      case "diagonal-right":
        if (!positions.inverted) {
          lastLine = positions.line + (word.length - 1);
          lastColumn = positions.column + (word.length - 1);

          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let i = positions.line, j = positions.column, indexLetter = 0; i <= lastLine; i++, j++, indexLetter++)
              if (board.bin[i][j] !== 0)
                if (board.letters[i][j] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }
        
        } else {
          lastLine = positions.line;
          positions.line += (word.length - 1);
          lastColumn = positions.column;
          positions.column += (word.length - 1);

          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let i = lastLine, j = lastColumn, indexLetter = (word.length - 1); i <= positions.line; i++, j++, indexLetter--)
              if (board.bin[i][j] !== 0)
                if (board.letters[i][j] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }
        }
        break;
        
      case "diagonal-left":
        if (!positions.inverted) {
          lastLine = positions.line + (word.length - 1);
          lastColumn = positions.column - (word.length - 1);

          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let i = positions.line, j = positions.column, indexLetter = 0; i <= lastLine; i++, j--, indexLetter++)
              if (board.bin[i][j] !== 0)
                if (board.letters[i][j] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }        
        } else {
          lastLine = positions.line;
          positions.line += (word.length - 1);
          lastColumn = positions.column;
          positions.column -= (word.length - 1);

          ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);
          if (!ExitFlag)
            for (let i = lastLine, j = lastColumn, indexLetter = (word.length - 1); i <= positions.line; i++, j--, indexLetter--)
              if (board.bin[i][j] !== 0)
                if (board.letters[i][j] !== word.charAt(indexLetter)){
                  ExitFlag = true;
                  break;
                }
        }
        break;

      default: break;
    }
    
    ExitFlag = Flag(ExitFlag, positions, lastLine, lastColumn, boardSize);

  } while (ExitFlag);

  return positions;
}

function Flag(ExitFlag, positions, lastLine, lastColumn, boardSize) {
  if (lastLine >= boardSize.height || lastColumn >= boardSize.width)
    ExitFlag = true;
  
  if (lastLine < 0 || lastColumn < 0 || positions.line < 0 || positions.column < 0)
    ExitFlag = true;
  
  if (positions.line >= boardSize.height || positions.column >= boardSize.width)
    ExitFlag = true;
  return ExitFlag;
}

export { InsertWordsInBoard };