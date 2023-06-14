import ddf.minim.*;
import processing.event.KeyEvent;

// Constants
final int ROWS = 3;
final int COLS = 3;
final int CELL_SIZE = 100;

// Player constants
final int EMPTY = 0;
final int PLAYER_X = 1;
final int PLAYER_O = 2;

// Game state variables
int[][] board;
int currentPlayer;
Minim minim;
AudioPlayer[] soundFiles; // Array of sound files
int currentMusicIndex; // Index of the current music file

void setup() {
  size(800, 800);
  board = new int[ROWS][COLS];
  currentPlayer = PLAYER_X;

  minim = new Minim(this);

  // Load sound files
  soundFiles = new AudioPlayer[2];
  soundFiles[0] = minim.loadFile("Central Cee Let Go.mp3");
  soundFiles[1] = minim.loadFile("fm-freemusic-happy-and-joyful-children.mp3");

  currentMusicIndex = 0; // Set initial music index
}

void draw() {
  background(255);
  drawBoard();
}

void drawBoard() {
  for (int row = 0; row < ROWS; row++) {
    for (int col = 0; col < COLS; col++) {
      int x = col * CELL_SIZE;
      int y = row * CELL_SIZE;
      rect(x, y, CELL_SIZE, CELL_SIZE);

      if (board[row][col] == PLAYER_X) {
        drawX(x, y);
      } else if (board[row][col] == PLAYER_O) {
        drawO(x, y);
      }
    }
  }
}

void drawX(int x, int y) {
  line(x + 20, y + 20, x + CELL_SIZE - 20, y + CELL_SIZE - 20);
  line(x + CELL_SIZE - 20, y + 20, x + 20, y + CELL_SIZE - 20);
}

void drawO(int x, int y) {
  ellipse(x + CELL_SIZE / 2, y + CELL_SIZE / 2, CELL_SIZE - 40, CELL_SIZE - 40);
}

void mouseClicked() {
  int row = mouseY / CELL_SIZE;
  int col = mouseX / CELL_SIZE;

  if (board[row][col] == EMPTY) {
    board[row][col] = currentPlayer;
    currentPlayer = currentPlayer == PLAYER_X ? PLAYER_O : PLAYER_X;
  }

  if (checkWin()) {
    println("Player " + (currentPlayer == PLAYER_X ? "X" : "O") + " wins!");
    soundFiles[currentMusicIndex].play();
    setup();
  } else if (checkDraw()) {
    println("It's a draw!");
    setup();
  }
}

boolean checkWin() {
  // Check rows
  for (int row = 0; row < ROWS; row++) {
    if (board[row][0] != EMPTY && board[row][0] == board[row][1] && board[row][1] == board[row][2]) {
      return true;
    }
  }

  // Check columns
  for (int col = 0; col < COLS; col++) {
    if (board[0][col] != EMPTY && board[0][col] == board[1][col] && board[1][col] == board[2][col]) {
      return true;
    }
  }

  // Check diagonals
  if (board[0][0] != EMPTY && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
    return true;
  }
  if (board[0][2] != EMPTY && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
    return true;
  }

  return false;
}

boolean checkDraw() {
  for (int row = 0; row < ROWS; row++) {
    for (int col = 0; col < COLS; col++) {
      if (board[row][col] == EMPTY) {
        return false;
      }
    }
  }
  return true;
}

void keyPressed() {
  if (key == '1') {
    currentMusicIndex = 0;
  } else if (key == '2') {
    currentMusicIndex = 1;
  }
}

void stop() {
  for (AudioPlayer soundFile : soundFiles) {
    soundFile.close();
  }
  minim.stop();
  super.stop();
}
