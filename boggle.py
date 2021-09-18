"""
File: boggle.py
Name: Zoe Lai
----------------------------------------
This program is the game boggle.
"""

import time

class Tree():
    def __init__(self, letter=None):
        self.letter = letter
        self.children = {}
        self.end = False

    # add a word letter-wise
    def add(self, word):
        if len(word):
            letter = word[0]
            word = word[1:]
            if letter not in self.children:
                self.children[letter] = Tree(letter)
            return self.children[letter].add(word)
        else:
            self.end = True
            return self

    # search a letter in the tree
    def search(self, letter):
        if letter not in self.children:
            return None
        return self.children[letter]

def find_word(board, tree, validated, row, col, path=None, cur_letter=None, word=None):
    """
    :param board: (list) a nested loop containing all the alphabets on the board
    :param tree: (Tree) a tree storing each alphabet of a word in the dictioanry
    :param validated: (set) a set of existent words in the dictionary
    :param row: (int) the nth row
    :param col: (int) the nth col
    :param path: (lst) a list containing a tuple of nth row and nth col that are walked before
    :param cur_letter: ()
    :param word: (str) current word
    """
    letter = board[row][col]
    if path is None or cur_letter is None or word is None:
        cur_letter = tree.search(letter)
        path = [(row, col)]
        word = letter
    else:
        cur_letter = cur_letter.search(letter)
        path.append((row, col))
        word = word + letter

    # Base Cases
    if cur_letter is None:
        return
    if cur_letter.end:  # If the end of the tree is reached
        validated.add(word)

    # find words by recursion
    # neighboring 8 alphabets
    for r in range(row-1, row + 2):
        for c in range(col-1, col + 2):
            if r >= 0 and r < 4 and c >= 0 and c < 4 and (r, c) not in path:
                find_word(board, tree, validated, r, c, path[:], cur_letter, word[:])


def is_incorrect_composition(user_str):
    """
    This function checks if the user input is valid.
    :param user_str: (str) user input str
    :return: (boolean)
    """
    for i in range(len(user_str)):
        if i % 2 == 0:
            if len(user_str[i]) != 1:
                return True
        else:  # space
            if user_str[i] != " ":
                return True


def main():
    """
    This program finds answers in the boggle game
    """
    print("Type 4 letters in each row. Please insert spaces between letters.")
    # create the board with rows
    total_str = ''
    count = 1
    while count <= 4:
        user_str = input(f'{count} st row:')
        if len(user_str) != 7:
            print('illegal format')
        elif len(user_str) == 7 and is_incorrect_composition(user_str):  # length of user_str = 7
            print('illegal format')
        else:
            count += 1
            cleaned_user_str = user_str.replace(" ", '')
            total_str += cleaned_user_str

    ##########################
    start = time.time()

    # process words into a nested list
    board = []
    row = []
    for alphabet in total_str:
        row.append(alphabet)
        if len(row) == 4:
            board.append(row)
            row = []

    # load dictionary into trees
    tree = Tree()
    dict = open('dictionary.txt', 'r')
    for line in dict:
        word = line.strip()
        tree.add(word)

    # store strings that exists in dictionary
    validated = set()

    # call the find word function for each alphabet on the board
    for row in range(0, 4):
        for col in range(0, 4):
            find_word(board, tree, validated, row, col)
    end = time.time()
    ##################################

    # print existent word
    ans = []
    for word in sorted(validated):
        if len(word) > 3:
            print('Found:', word)
            ans.append(word)
    print(f'There are {len(ans)} words in total')
    print(f'The speed of your boggle algorithm: {end - start} seconds.')


if __name__ == '__main__':
    main()