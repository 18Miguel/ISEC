import React, { useState, useEffect } from "react";
import "./invoice.css";
import timerSound from "../../resources/timer_sound.mp3"

const Invoice = (props) => {
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USESTATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const [timer, setTimer] = useState(0);
  const [timerId, setTimerId] = useState(undefined);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  useEffect(() => {
    if (!props.gameStarted) {
      setTimerId(clearInterval(timerId));
      setTimer(0);
    }

    if (props.gameStarted) {
      setTimerId(setInterval(() => {
          let nextTimer;

          setTimer((previousState) => {
            nextTimer = previousState - 1;
            if (nextTimer === 10)
              document.querySelector('#game-time').classList.add("ten-sec-left");
            
            /* if (nextTimer === 0){ props.onGameStarted(); } */
            
            return nextTimer;
          });
      }, 1000));

    } else if (timer !== 0) {
      setTimer(0);
      props.setPoints(0);
    }

    return () => {
      if (timerId)
        setTimerId(clearInterval(timerId));
    };
  }, [props.gameStarted]);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* Termina jogo quando o tempo chega a zero */
  useEffect(() => {
    if (timer === 0 && props.gameStarted) {
      new Audio(timerSound).play();
      props.onGameStarted();
    }
    document.querySelector(".message").classList.add("hide"); /* Porque a função a cima é executada '()' */
  }, [timer]);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* Termina jogo quando as palavras forem encontradas */
  useEffect(() => {
    if (props.gameStarted && props.words.length === 0){
      setTimerId(clearInterval(timerId)); /* Para o tempo */
      document.querySelector('#game-time').classList.remove("intermittent-time-effect");
      setTimeout(() => {      /* Espera X segundos terminar */
        props.onGameStarted();
      }, 1000*2.5);
    }
    if (props.gameStarted) {
      props.setPoints(props.points + (((timer / 2) + props.words.length) / 2));
    }
  }, [props.words]);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const levelMenu = () => {
    document.querySelector(".option-content").classList.toggle("show");
  };

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const handleSelectedLevel = (event) => {
    props.setSelectedLevel(event.target.getAttribute("data-value"));
    document.querySelector(".select-content").firstChild.textContent = event.target.innerHTML;
    document.querySelector(".message").classList.add("hide");
    switch (event.target.getAttribute("data-value")) {
      case "1":
        props.setWords(["ANGULAR","BACKBONE","DANIEL","FERIAS","HTML","MIGUEL","VUE"]);
        props.setBoardSize({ width: 10, height: 10 });
        setTimer(100);
        break;
      case "2":
        props.setWords(["REACT","JAVASCRIPT","HTML","CSS","BACKBONE","ANGULAR","BOOTSTRAP","VUE"]);
        props.setBoardSize({ width: 12, height: 12 });
        setTimer(120);
        break;
      case "3":
        props.setWords(["REACT","JAVASCRIPT","HTML","CSS","BACKBONE","ANGULAR","ISEC","BOOTSTRAP","VUE"]);
        props.setBoardSize({ width: 14, height: 14 });
        setTimer(140);
        break;
      default: break;
    }
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  const insertWord = () => {
    const InsertWordInput = document.querySelector("#insert-word-input");
    document.querySelector(".message").classList.add("hide");

    if (props.selectedLevel === "0") {
      document.querySelector(".message").classList.remove("hide");
      InsertWordInput.style.border = "2px solid #fa4242";
      setTimeout(() => {
        InsertWordInput.style.border = "2px solid #efefef";
      }, 1000*1);

    } else {
      if (props.words.length < 12) {
        let spaceFlag = false;
        for (let i = 0; i < InsertWordInput.value.length; i++)
          if (InsertWordInput.value[i] === " ")
            spaceFlag = true;
        
        if (InsertWordInput.value !== "" && !spaceFlag) {
          let wordsCPY = props.words;
          wordsCPY.push(InsertWordInput.value.toUpperCase());
          props.setWords(wordsCPY);

          InsertWordInput.style.border = "2.1px solid #85fa42";
          InsertWordInput.placeholder = "A palavra foi inserida";
          InsertWordInput.value = "";
          
        } else {
          InsertWordInput.value = "";
          InsertWordInput.style.border = "2.1px solid #fa4242";
        }
      } else {
        InsertWordInput.value = "";
        InsertWordInput.style.border = "2.1px solid #f2a74a";
        InsertWordInput.placeholder = "Limite atingido!";
      }
    }

    setTimeout(() => {
      InsertWordInput.style.border = "2px solid #efefef";
      InsertWordInput.placeholder = "Intruduza uma palavra.."
    }, 1000*1.2);
  }

  useEffect(() => {
    const InsertWordInput = document.querySelector("#insert-word-input");
    if (props.selectedLevel === "0") {
      InsertWordInput.classList.add("disabled");
      InsertWordInput.value = "Selecione nível de jogo";
      
    } else {
      InsertWordInput.placeholder = "Intruduza uma palavra.."
      setTimeout(() => {
        InsertWordInput.classList.remove("disabled");
        InsertWordInput.value = ""
      }, 1000);
    }
  }, [props.selectedLevel]);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  return (
    <div id="invoice-mobile-background" className={`${props.spoonsMenu ? "show" : ""}`}>
      <div id="invoice" className="option-level">
        <div id="invoice-inner">
          <div id="invoice-front">
            <div className="select-level invoice-object">
              <div className="select-content" onClick={levelMenu}>
                Nível de Jogo..
                <div className="option-content">
                  <div
                    className="select-option-level"
                    data-value="1"
                    onClick={handleSelectedLevel}
                  >
                    Básico
                  </div>
                  <div
                    className="select-option-level"
                    data-value="2"
                    onClick={handleSelectedLevel}
                  >
                    Intermédio
                  </div>
                  <div
                    className="select-option-level"
                    data-value="3"
                    onClick={handleSelectedLevel}
                  >
                    Avançado
                  </div>
                </div>
              </div>
            </div>

            <p role="alert" className={"message invoice-object hide"}>
              Selecione o Nível de Jogo!
            </p>

            <div id="insert-word">
              <input id="insert-word-input" type="text" placeholder="Intruduza uma palavra.." maxLength={props.boardSize.width || props.boardSize.height}></input>
              <button id="insert-word-button" type="button" onClick={insertWord}>Inserir Palavra</button>
            </div>
            

            <div id="start-button">
              <button type="button" className="start-button invoice-object" onClick={props.onGameStarted}>
                <div><div></div></div>
                {props.gameStarted ? "Parar Jogo" : "Iniciar Jogo"}
              </button>
            </div>
          </div>
          {/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */}
          <div id="invoice-back">
            <div id="words">
              {props.words.map((word, index) => {
                return (
                  <p key={index}>
                    {word.concat(".........................".slice(word.length))}
                  </p>
                );
              })}
              <p id="words-total">{`${props.words.length} palavras a procurar.`}</p>
            </div>

            <dl id="invoice-time">
              <dt>Tempo de Jogo: </dt>
              <dd id="game-time">{timer}</dd>
            </dl>

            <dl id="invoice-points">
              <dt>Pontuação: </dt>
              <dd id="points">{props.points}</dd>
            </dl>

            <div id="start-button">
              <button type="button" className="start-button invoice-object active" onClick={props.onGameStarted}>
                <div><div></div></div>
                {props.gameStarted ? "Parar Jogo" : "Iniciar Jogo"}
              </button>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}

export default Invoice;