import profile from "../static/profile.jpg";
import "./main.css";
import { Elm } from "./Main.elm";
import * as serviceWorker from "./serviceWorker";

const app = Elm.Main.init({
  node: document.getElementById("root"),
  flags: {
    profilePicture: profile,
  },
});

app.ports.printPage.subscribe(() => {
  window.print();
});

window.addEventListener("load", () => {
  const optionsBar = document.getElementById("options-bar");

  const getCurrentScroll = () =>
    window.scrollY || document.documentElement?.scrollTop;

  let previousScroll = getCurrentScroll();
  let wasScrolling = false;

  window.addEventListener("scroll", () => {
    const currentScroll = getCurrentScroll();
    const isScrollingDown = currentScroll > previousScroll;
    const isScrollingUp = currentScroll < previousScroll;
    previousScroll = currentScroll;

    if (isScrollingDown && !wasScrolling) {
      optionsBar.classList.add("hidden");
      wasScrolling = true;
    } else if (isScrollingUp && wasScrolling) {
      optionsBar.classList.remove("hidden");
      wasScrolling = false;
    }
  });
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
