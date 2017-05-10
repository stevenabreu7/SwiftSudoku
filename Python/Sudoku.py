class Board:
    def __init__(self):
        """Creates a new, fresh Sudoku board."""
        self.fields = [[0 for i in range(9)] for j in range(9)]
        self.correct = [[None for i in range(9)] for j in range(9)]

    def __str__(self):
        """String representation for printing in the command line."""
        res = ""
        for i in range(9):
            for j in range(9):
                res += str(self.fields[i][j])
                res += " | " if j == 2 or j == 5 else "  "
            res += "\n" + "-" * 27 + "\n" if i == 2 or i == 5 else "\n"
        return res

    def parseBoard(self, s):
        """Parses a board from a string."""
        s = "".join(s.split())
        for i in range(9):
            for j in range(9):
                num = int(s[i*9+j])
                self.makeMove(i,j,num)

    def makeMove(self, row, col, number):
        """Returns whether the move was valid or not."""
        if row < 0 or row > 8 or col < 0 or col > 8:
            return False
        elif self.fields[row][col] != 0:
            return False
        wrong = self.wrongMove(row, col, number)
        if wrong:
            print("wrong move!", row, col, number)
        self.correct[row][col] = not wrong
        self.fields[row][col] = number
        return True

    def wrongMove(self, row, col, number):
        """Checks whether this move is wrong or not (before having made the move)."""
        if number < 1 or number > 9:
            print("Incorrect number.")
            return True
        # check row
        for i in range(9):
            if self.fields[row][i] == number:
                print("Row.")
                return True
        # check column
        for i in range(9):
            if self.fields[i][col] == number:
                print("Col.")
                return True
        # check mini square
        topLeftY = (col // 3) * 3
        topLeftX = (row // 3) * 3
        for i in range(3):
            for j in range(3):
                if self.fields[topLeftX+i][topLeftY+j] == number:
                    print("Square.", i,j,number, topLeftX, topLeftY)
                    return True
        return False

    def isFull(self):
        """Checks whether the board is full (has no zeros)."""
        hasZero = any(0 in row for row in self.fields)
        return not hasZero

    def printBoard(self):
        """Print the board with a small separation afterwards."""
        print(self)
        print(("*"*27 + "\n") * 2)

    def play(self):
        """Play a game of sudoku."""
        while not self.isFull():
            self.printBoard()
            moveRow = int(input("Enter row: "))
            moveCol = int(input("Enter col: "))
            moveNum = int(input("Enter number: "))
            result = self.makeMove(moveRow, moveCol, moveNum)
            if result:
                self.printBoard()
            else:
                print("invalid move! try again")
                continue
        if any(False in row for row in self.correct):
            print("Wrong.")
        else:
            print("You win!")

b = Board()
b.printBoard()
b.parseBoard("726493815315728946489651230852147693673985124941362758194836572567214389238579460")
b.printBoard()
b.play()
