import React from "react";
import Invoice from "./invoice";
import Board from "./board";
import "./mobile.css";
import "./main.css";

function Main(props) {
  return (
    <main>
      <div id="container">
        <Invoice
          spoonsMenu={props.spoonsMenu}
          setSelectedLevel={props.setSelectedLevel}
          selectedLevel={props.selectedLevel}
          setWords={props.setWords}
          boardSize={props.boardSize}
          setBoardSize={props.setBoardSize}
          gameStarted={props.gameStarted}
          onGameStarted={props.onGameStarted}
          words={props.words}
          points={props.points}
          setPoints={props.setPoints}
        />
        <Board
          gameStarted={props.gameStarted}
          board={props.board}
          words={props.words}
          setWords={props.setWords}
          setBoard={props.setBoard}
        />
      </div>
    </main>
  );
}

export default Main;
