import React, { /* useState, */ useEffect } from "react";
import "./header.css";
import "./spoonMenu.css";

/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
function Header(props) {
  /* const [spoonsMenu, setSpoonsMenu] = useState(false); */

  const openSpoonsMenu = () => {
    document.querySelector("#invoice-mobile-background").classList.toggle("show");
    
    if (props.spoonsMenu) {
      props.setSpoonsMenu(false);
    } else {
      props.setSpoonsMenu(true);
    }
  };

  useEffect(() => {
    if (props.gameStarted)
      document.querySelector("#invoice-mobile-background").classList.remove("show");
  }, [props.gameStarted]);

  return (
    <header>
      {/* <h2>Sopa de Letras</h2> */}
      <div className={`spoon_menu ${props.spoonsMenu ? "open" : ""}`} onClick={openSpoonsMenu}>
        <div></div>
        <div></div>
      </div>
    </header>
  );
}

export default Header;
