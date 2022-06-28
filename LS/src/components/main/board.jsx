import React, { useState, useEffect } from "react";
import checkSelection from "./checkSelection";
import "./board.css"

const Board = (props) => {
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USESTATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const [firstHouveredLeter, setFirstHouveredLeter] = useState("");
  const [lastHouveredLeter, setLastHouveredLeter] = useState("");
  const [colorsArray, setColorsArray] = useState([]);
  const [colors, setColors] = useState([]);
  const [randomColorIndex, setRandomColorIndex] = useState(Math.floor(Math.random() * colors.length));
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */ 
  let color = undefined;
  let letterKey = 0;
  let newWords = [];
  
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const checkIfIsHighlighted = (pos) => {
    return firstHouveredLeter === pos || lastHouveredLeter === pos;
  };

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  useEffect(()=>{
    newWords = checkSelection(firstHouveredLeter, lastHouveredLeter, props.board, props.words, props.setBoard);

    if (newWords !== undefined){
      props.setWords(newWords);

      colors.splice(randomColorIndex, 1);
      setColors(colors);
      setRandomColorIndex(Math.floor(Math.random() * colors.length));

      if (props.words.length === 0) {
        setTimeout(() => {      /* Espera X segundos terminar */
          for (let linhas = 0; linhas < props.board.bin.length; linhas++)
            for (let colunas = 0; colunas < props.board.bin[linhas].length; colunas++)
              props.board.bin[linhas][colunas] = 0;
          props.setBoard(props.board);

          setColorsArray([]);
        }, 1000*2.45);
      }        
    }
  }, [lastHouveredLeter]);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  useEffect(() => {
    setColors([
      "#bda24a",
      "#92f430",
      "#30f4a2",
      "#3071f4",
      "#9230f4",
      "#79B0C9",
      "#323A4F",
      "#3F1813",
      "#7e0000",
      "#458eb5",
      "#585a62",
      "#3e42f4",
      "#6301ff",
      "#7d3267",
      "#74353B"
    ]);
    setColorsArray([]);
  }, [props.gameStarted]);
  
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const paintWordFound = (boardBin, letterKey) => {
    if (boardBin !== 1) {
      color = "";
      return;
    }

    let flagColor = false;
    for (let i = 0; i < colorsArray.length; i++)
      if (colorsArray[i].key === letterKey) {
        flagColor = true;
        break;
      }
    
    if (!flagColor) { /* Adiciona nova cor */
      color = colors[randomColorIndex];
      colorsArray.push({key: letterKey, color: colors[randomColorIndex],});
      setColorsArray(colorsArray);
      
    } else { /* procura cor existente */
      for (let i = 0; i < colorsArray.length; i++)
        if (colorsArray[i].key === letterKey) {
          color = colorsArray[i].color;
          break;
        }
    }
  };

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  return (
    <div id="board">
      <div id="bowlOfSoup">
        <table>
          <tbody>
            {props.board.letters.map((row, rowIndex) => {
              return (
                <tr className={`boardChars`} key={rowIndex}>
                  {row.map((letter, columnIndex) => {
                    const currentPos = `${rowIndex},${columnIndex}`;
                    const isHighlighted = checkIfIsHighlighted(currentPos);
                    paintWordFound(props.board.bin[rowIndex][columnIndex], letterKey);

                    return (
                      <td className={`boardChar ${isHighlighted ? "boardCharHover" : ""} `} /* boardCharSelected */
                        style={{backgroundColor: `${color}`}}
                        key={letterKey++}
                        onMouseDown={() => {
                          setFirstHouveredLeter(currentPos);
                        }}
                        onMouseUp={() => {
                          setFirstHouveredLeter("");
                          setLastHouveredLeter("");
                        }}
                        onMouseOver={() => {
                          if (firstHouveredLeter.length > 0) {
                            setLastHouveredLeter(currentPos); 
                          }
                        }}
                      >
                        {letter}
                      </td>
                    )
                  })}
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Board;
