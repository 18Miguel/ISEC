import React, { useState, useEffect } from "react";
import {
  Header,
  Main,
  InitializeBoard,
  InsertWordsInBoard,
  Footer,
} from "./components/index";
import "./App.css";

function App() {
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USESTATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const [boardSize, setBoardSize] = useState({ width: 12, height: 12 });
  const [board, setBoard] = useState(InitializeBoard(boardSize.height, boardSize.width));
  const [words, setWords] = useState([]);
  const [gameStarted, setGameStarted] = useState(false);
  const [selectedLevel, setSelectedLevel] = useState("0");
  const [points, setPoints] = useState(0);
  const [spoonsMenu, setSpoonsMenu] = useState(false);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  useEffect(() => {
    setBoard(InitializeBoard(boardSize.height, boardSize.width));
  }, [boardSize]);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HANDLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  function handleSetSelectedLevel(SelectedLevel){
    setSelectedLevel(SelectedLevel);
  }

  function handleSetWords(Words){
    setWords([...Words]);
  }

  function handleSetPoints(Points){
    setPoints(Points);
  }
  
  function handleSetBoardSize(BoardSize){
    setBoardSize(BoardSize);
  }

  function handleSetBoard(board){
    setBoard(board);
  }

  function handleGameStart() {
    const Select_content = document.querySelector(".select-content");
    const AlertMessage = document.querySelector(".message");
    const StartButton = document.querySelector(".start-button");
    const InvoiceInner = document.querySelector("#invoice-inner");
    const GameTimer = document.querySelector('#game-time');

    if (gameStarted) {
      setGameStarted(false);
      setSelectedLevel("0");
      Select_content.firstChild.textContent = "Nível de Jogo..";
      Select_content.classList.remove("disabled");
      StartButton.classList.remove("active");
      InvoiceInner.classList.remove("rotated");
      GameTimer.classList.remove("ten-sec-left");
      /* setTimerId(clearInterval(timerId));
      setTimer(0);  */     
      setBoard(InitializeBoard(12, 12));

    } else {
      if (selectedLevel === "0") {
        AlertMessage.classList.remove("hide");
        
      } else {
        InvoiceInner.classList.add("rotated");
        AlertMessage.classList.add("hide");
        Select_content.classList.add("disabled");
        StartButton.classList.add("active");
        GameTimer.classList.add("intermittent-time-effect");
        setGameStarted(true);
        setPoints(0);
        setBoard(InsertWordsInBoard(board, words, boardSize));
      }
    }
  }

  function handleSpoon() {
    if (spoonsMenu)
      setSpoonsMenu(false);
    else
      setSpoonsMenu(true);
  }

  return (
    <div id="grid-container">
      <Header 
        gameStarted={gameStarted}
        spoonsMenu={spoonsMenu}
        setSpoonsMenu={handleSpoon}
      />
      <Main
        spoonsMenu={spoonsMenu}
        setSelectedLevel={handleSetSelectedLevel}
        selectedLevel={selectedLevel}
        words={words}
        setWords={handleSetWords}
        boardSize={boardSize}
        setBoardSize={handleSetBoardSize}
        gameStarted={gameStarted}
        onGameStarted={handleGameStart}
        points={points}
        setPoints={handleSetPoints}

        board={board}
        setBoard={handleSetBoard}
      />
      <Footer />
    </div>
  );
}

export default App;
