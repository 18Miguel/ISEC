export default function checkSelection(firstHouveredLeter, lastHouveredLeter, board, words, setBoard) {
  if(firstHouveredLeter === "" || lastHouveredLeter === "")
    return undefined;
  let aux = [];
  let arrayfirstHouveredLeter = firstHouveredLeter.split(",");
  let arraylastHouveredLeter = lastHouveredLeter.split(",");

  let firstLinha = parseInt(arrayfirstHouveredLeter[0],10);
  let firstColuna = parseInt(arrayfirstHouveredLeter[1],10);
  let lastLinha = parseInt(arraylastHouveredLeter[0],10);
  let lastColuna = parseInt(arraylastHouveredLeter[1],10);

  let newArrayWords = undefined;
    
  if (firstLinha === lastLinha && firstColuna !== lastColuna) { //Horizontal
    if (firstColuna>lastColuna) {
      for (let colunas = lastColuna; colunas <= firstColuna; colunas++) {
        aux.push(board.letters[firstLinha][colunas]);
      }
        let word = "";
        for (let index = 0; index < aux.length; index++) {
            word += aux[index];
        }
        
        newArrayWords = checkPalavra(words, word);
        if (newArrayWords !== undefined) {
          paintBoard("horizontal", lastLinha, lastColuna, firstLinha, firstColuna, board, setBoard);
          return newArrayWords;
        }
      //}
    } else {
      for (let colunas = firstColuna; colunas <= lastColuna; colunas++) {
        aux.push(board.letters[firstLinha][colunas]);
      }
        let word = "";
        for (let index = 0; index < aux.length; index++) {
            word += aux[index];
        }

        newArrayWords = checkPalavra(words, word);
        if (newArrayWords !== undefined) {
          paintBoard("horizontal", firstLinha, firstColuna, lastLinha, lastColuna, board, setBoard);
          return newArrayWords;
        }
      //}
    }
    aux = [];
  
  } else if (firstLinha !== lastLinha && firstColuna === lastColuna) { //Vertical
    if (firstLinha > lastLinha) {
      for (let linha = lastLinha; linha <= firstLinha; linha++) {
        aux.push(board.letters[linha][firstColuna]);
      }
        let word = "";
        for (let index = 0; index < aux.length; index++) {
            word += aux[index];
        }
        
        newArrayWords = checkPalavra(words, word);
        if (newArrayWords !== undefined) {
          paintBoard("vertical", lastLinha, lastColuna, firstLinha, firstColuna, board, setBoard);
          return newArrayWords;
        }
      //}
    } else {
      for (let linha = firstLinha; linha <= lastLinha; linha++) {
        aux.push(board.letters[linha][firstColuna]);
      }
        let word = "";
        for (let index = 0; index < aux.length; index++) {
            word += aux[index];
        }
        
        newArrayWords = checkPalavra(words, word);
        if (newArrayWords !== undefined) {
          paintBoard("vertical", firstLinha, firstColuna, lastLinha, lastColuna, board, setBoard);
          return newArrayWords;
        }
      //}
    }
    aux = [];
  
  } else if (firstLinha !== lastLinha && firstColuna !== lastColuna) { //Diagonal
    if (firstLinha < lastLinha && firstColuna < lastColuna) {
      for (let linha = firstLinha, coluna = firstColuna; linha <= lastLinha && coluna <= lastColuna; linha++, coluna++) {
        if((linha >= 0 && linha < board.letters.length) && (linha >= 0 && coluna < board.letters.length)){
          aux.push(board.letters[linha][coluna]);
        }
      }
          let word = "";
          for (let index = 0; index < aux.length; index++) {
            word += aux[index];
          }
          
          newArrayWords = checkPalavra(words, word);
          if (newArrayWords !== undefined) {
            paintBoard("diagonal1", firstLinha, firstColuna, lastLinha, lastColuna, board, setBoard);
            return newArrayWords;
          }
        //}
      //}
    } else if (firstLinha > lastLinha && firstColuna > lastColuna) {
      for (let linha = lastLinha,  coluna = lastColuna;linha <= firstLinha && coluna <= firstColuna; linha++,coluna++) {
        if ((linha >= 0 && linha < board.letters.length) && (linha >= 0 && coluna < board.letters.length)) {
          aux.push(board.letters[linha][coluna]);
        }
      }
          let word = "";
          for (let index = 0; index < aux.length; index++) {
            word += aux[index];
          }

          newArrayWords = checkPalavra(words, word);
          if (newArrayWords !== undefined) {
            paintBoard("diagonal2", firstLinha, firstColuna, lastLinha, lastColuna, board, setBoard);
            return newArrayWords;
          }
        //}
      //}
    } else if (firstLinha < lastLinha && firstColuna > lastColuna) {
      for (let linha = firstLinha, coluna = firstColuna; linha <= lastLinha && coluna >= lastColuna; linha++,coluna--) {
        if ((linha >= 0 && linha < board.letters.length) && (linha >= 0 && coluna < board.letters.length)) {
          aux.push(board.letters[linha][coluna]);
        }
      }
          
          let word = "";
          for (let index = 0; index < aux.length; index++) {
            word += aux[index];
          }
          
          newArrayWords = checkPalavra(words, word);
          if (newArrayWords !== undefined) {
            paintBoard("diagonal3", firstLinha, firstColuna, lastLinha, lastColuna, board, setBoard);
            return newArrayWords;
          }
        //}
      //}
    } else if (firstLinha > lastLinha && firstColuna < lastColuna) {
      for (let linha = firstLinha, coluna = firstColuna; linha >= lastLinha && coluna <= lastColuna; linha--,coluna++) {
        if ((linha >= 0 && linha < board.letters.length) && (linha >= 0 && coluna < board.letters.length)) {
          aux.push(board.letters[linha][coluna]);
        }
      }
          let word = "";
          for (let index = 0; index < aux.length; index++) {
            word += aux[index];
          }
          
          newArrayWords = checkPalavra(words, word);
          if (newArrayWords !== undefined) {
            paintBoard("diagonal4", firstLinha, firstColuna, lastLinha, lastColuna, board, setBoard);
            return newArrayWords;
          }
        //}
      //}
    }
    aux = []; 
  }
  return undefined;
}

function checkPalavra(arrayWords, word){
  for (let i = 0; i < arrayWords.length; i++) {
    if (arrayWords[i] === word) {
      arrayWords.splice(i, 1);
      return arrayWords;
    }
  }
  
  word = word.split('').reverse().join('');
  for (let i = 0; i < arrayWords.length; i++) {
    if (arrayWords[i] === word) {
      arrayWords.splice(i, 1);
      return arrayWords;
    }
  }
  return undefined;
}

function paintBoard(direction,firstLinha,firstColuna,lastLinha,lastColuna,board,setBoard){
  switch (direction) {
    case "horizontal":
      for (let linha = firstLinha; linha <= lastLinha; linha++) {
        for (let coluna = firstColuna; coluna <= lastColuna; coluna++) {
          board.bin[linha][coluna] = 1;      
        }
      }
      //setBoard(board);
      break;
    
    case "vertical":
      for (let coluna = firstColuna; coluna <= lastColuna; coluna++) {
        for (let linha = firstLinha; linha <= lastLinha; linha++) {
          board.bin[linha][coluna] = 1;      
        }
      }
      //setBoard(board);
      break;

    case "diagonal1":
      for(let linha = firstLinha, coluna = firstColuna; linha <= lastLinha && coluna <= lastColuna; linha++,coluna++) {
          board.bin[linha][coluna] = 1;
      }
      //setBoard(board);
      break;

    case "diagonal2":
      for(let linha = lastLinha, coluna = lastColuna; linha <= firstLinha && coluna <= firstColuna; linha++,coluna++) {
          board.bin[linha][coluna] = 1;
      }
      //setBoard(board);
      break;

    case "diagonal3":
      for(let linha = firstLinha, coluna = firstColuna; linha <= lastLinha && coluna >= lastColuna; linha++,coluna--) {
          board.bin[linha][coluna] = 1;
      }
      //setBoard(board);
      break;

    case "diagonal4":
      for(let linha = firstLinha, coluna = firstColuna; linha >= lastLinha && coluna <= lastColuna; linha--,coluna++) {
          board.bin[linha][coluna] = 1;
      }
      //setBoard(board);
      break;
      default: break;
    }
  setBoard(board);
}
