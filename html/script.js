$(document).ready(function () {
  var sound = new Howl({
    src: ["https://cdn.discordapp.com/attachments/856774459036925962/1254137252733255690/keyboard-sound.wav?ex=667865d5&is=66771455&hm=cb6e9a7b68dd794253ace8511b8c2b9dcc860aeb63c6df54250f8b5bad732153&"], // Replace with your sound file URL
    volume: 0.5,
  });

  function resetTerminal() {
    $(".terminal").html(`
      <p class="terminal__line"><span class="green">Welcome:</span> <span class="blue">&lt;</span><span class="green" id="ip"></span><span class="blue">&gt;</span></p>
      <p class="terminal__line">Panel interface completed.</p>
      <p class="terminal__line">Navigation portals fetched:</p>
      <p class="terminal__line">Inject <span class="blue">Help.md</span> to <span class="blue">C:\\Users\\</span><span class="console"></span></p>
    `);
  }

  $("#search__input").on("keydown", function (e) {
    if (e.key === "Enter") {
      e.preventDefault();
      var input = $(this).val().trim();
      $(this).val("");
      var command = input.split(" ")[0];
      var args = input.split(" ").slice(1);

      $.post(
        "https://ghs_hterminal/sendCommand",
        JSON.stringify({
          command: command,
          args: args,
        })
      );

      var newLine = $('<p class="terminal__line">' + input + "</p>");
      $(".terminal").append(newLine);
      newLine.css("opacity", 0).animate({ opacity: 1 }, 1000);
      $(".terminal").scrollTop($(".terminal")[0].scrollHeight);
    } else {
      sound.play();
    }
  });

  window.addEventListener("message", function (event) {
    const data = event.data;
    if (data.type === "UI") {
      document.body.style.display = "flex";
    } else if (data.type === "hide") {
      resetTerminal();
      document.body.style.display = "none";
    } else if (data.type === "TERMINAL_OUTPUT") {
      var newOutput = $('<p class="terminal__line">' + data.output + "</p>");
      $(".terminal").append(newOutput);
      newOutput.css("opacity", 0).animate({ opacity: 1 }, 1000);
      $(".terminal").scrollTop($(".terminal")[0].scrollHeight);
    } else if (data.type === "CLEAR_TERMINAL") {
      $(".terminal").html("");
    }
  });

  // Add event listener for the Escape key
  $(document).on("keydown", function (e) {
    if (e.key === "Escape") {
      $.post("https://ghs_hterminal/sendCommand", JSON.stringify({ command: "exit" }));
      document.body.style.display = "none";
      resetTerminal();
    }
  });

  // Initialize the terminal with the start message
  resetTerminal();
});