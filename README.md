
from pygame.locals import *
import os
import numpy as np
import random
import pygame
import sys
import math



backGroundColor = (0,0,0)
boardColor = (250,0,250)
firstPlayerColor = (0,204,102)
secondPlayerColor = (255,255,250)
fontColor=(255,255,0)

rowNum = 6
columnNum = 7



EMPTY = 0
PLAYER_PIECE = 1
AI_PIECE = 2

WINDOW_LENGTH = 4
PLAYER = 0
AI = 1
#............................................................................
def initializeBoard():
    board = np.zeros((rowNum,columnNum))
    return board

def reserveCell(board, row, col, piece):
    board[row][col] = piece

def isFreeSpace(board, col):
    return board[rowNum-1][col] == 0

def get_next_open_row(board, col):
    for r in range(rowNum):
        if board[r][col] == 0:
            return r

def printBoarder(board):
    print(np.flip(board, 0))



#..................................................................

def isWinner(board, piece):




    # Check if win by column
    for columnRank in range(columnNum-3):
        for r in range(rowNum):
            if board[r][columnRank] == piece and board[r][columnRank+1] == piece and board[r][columnRank+2] == piece and board[r][columnRank+3] == piece:
                return True

    # Check if win by row
    for columnRank in range(columnNum):
        for r in range(rowNum-3):
            if board[r][columnRank] == piece and board[r+1][columnRank] == piece and board[r+2][columnRank] == piece and board[r+3][columnRank] == piece:
                return True

     # Check if win by diagonal
    for columnRank in range(columnNum-3):
        for r in range(rowNum-3):
            if board[r][columnRank] == piece and board[r+1][columnRank+1] == piece and board[r+2][columnRank+2] == piece and board[r+3][columnRank+3] == piece:
                return True

    # Check if win by inversediagonal
    for columnRank in range(columnNum-3):
        for r in range(3, rowNum):
            if board[r][columnRank] == piece and board[r-1][columnRank+1] == piece and board[r-2][columnRank+2] == piece and board[r-3][columnRank+3] == piece:
                return True


#......................................................................................


def evaluate_window(window, piece):
    score = 0
    opp_piece = PLAYER_PIECE
    if piece == PLAYER_PIECE:
        opp_piece = AI_PIECE

    if window.count(piece) == 4:
        score += 100
    elif window.count(piece) == 3 and window.count(EMPTY) == 1:
        score += 5
    elif window.count(piece) == 2 and window.count(EMPTY) == 2:
        score += 2

    if window.count(opp_piece) == 3 and window.count(EMPTY) == 1:
        score -= 4

    return score


#......................................................................
def score_position(board, piece):
    score = 0

    ## Score center column
    center_array = [int(i) for i in list(board[:, columnNum//2])]
    center_count = center_array.count(piece)
    score += center_count * 3

    ## Score Horizontal
    for r in range(rowNum):
        row_array = [int(i) for i in list(board[r,:])]
        for c in range(columnNum-3):
            window = row_array[c:c+WINDOW_LENGTH]
            score += evaluate_window(window, piece)

    ## Score Vertical
    for c in range(columnNum):
        col_array = [int(i) for i in list(board[:,c])]
        for r in range(rowNum-3):
            window = col_array[r:r+WINDOW_LENGTH]
            score += evaluate_window(window, piece)

    ## Score posiive sloped diagonal
    for r in range(rowNum-3):
        for c in range(columnNum-3):
            window = [board[r+i][c+i] for i in range(WINDOW_LENGTH)]
            score += evaluate_window(window, piece)

    for r in range(rowNum-3):
        for c in range(columnNum-3):
            window = [board[r+3-i][c+i] for i in range(WINDOW_LENGTH)]
            score += evaluate_window(window, piece)

    return score

def terminaState(board):
    return isWinner(board, PLAYER_PIECE) or isWinner(board, AI_PIECE) or len(get_valid_locations(board)) == 0
#................................................minimax algorithms............................................
def minimaxWithPrunning(board, depth, alpha, beta, maximizingPlayer):
    valid_locations = get_valid_locations(board)
    is_terminal = terminaState(board)
    if depth == 0 or is_terminal:
        if is_terminal:
            if isWinner(board, AI_PIECE):
                return (None, 100000000000000)
            elif isWinner(board, PLAYER_PIECE):
                return (None, -10000000000000)
            else:
                return (None, 0)
        else: 
            return (None, score_position(board, AI_PIECE))
    if maximizingPlayer:
        value = -math.inf
        column = random.choice(valid_locations)
        for col in valid_locations:
            row = get_next_open_row(board, col)
            b_copy = board.copy()
            reserveCell(b_copy, row, col, AI_PIECE)
            new_score = minimaxWithPrunning(b_copy, depth-1, alpha, beta, False)[1]
            if new_score > value:
                value = new_score
                column = col
            alpha = max(alpha, value)
            if alpha >= beta:
                break
        return column, value

    else: 
        value = math.inf
        column = random.choice(valid_locations)
        for col in valid_locations:
            row = get_next_open_row(board, col)
            b_copy = board.copy()
            reserveCell(b_copy, row, col, PLAYER_PIECE)
            new_score = minimaxWithPrunning(b_copy, depth-1, alpha, beta, True)[1]
            if new_score < value:
                value = new_score
                column = col
            beta = min(beta, value)
            if alpha >= beta:
                break
        return column, value







def minimax(board, depth, alpha, beta, maximizingPlayer):
    valid_locations = get_valid_locations(board)
    is_terminal = terminaState(board)
    if depth == 0 or is_terminal:
        if is_terminal:
            if isWinner(board, AI_PIECE):
                return (None, 100000000000000)
            elif isWinner(board, PLAYER_PIECE):
                return (None, -10000000000000)
            else:
                return (None, 0)
        else: 
            return (None, score_position(board, AI_PIECE))
    if maximizingPlayer:
        value = -math.inf
        column = random.choice(valid_locations)
        for col in valid_locations:
            row = get_next_open_row(board, col)
            b_copy = board.copy()
            reserveCell(b_copy, row, col, AI_PIECE)
            new_score = minimax(b_copy, depth-1, alpha, beta, False)[1]
            if new_score > value:
                value = new_score
                column = col
            alpha = max(alpha, value)
            if alpha >= beta:
                break
        return column, value

    else: 
        value = math.inf
        column = random.choice(valid_locations)
        for col in valid_locations:
            row = get_next_open_row(board, col)
            b_copy = board.copy()
            reserveCell(b_copy, row, col, PLAYER_PIECE)
            new_score = minimax(b_copy, depth-1, alpha, beta, True)[1]
            if new_score < value:
                value = new_score
                column = col
            beta = min(beta, value)
            if alpha >= beta:
                break
        return column, value










#..........................................end of algorithms......................................
def get_valid_locations(board):
    valid_locations = []
    for col in range(columnNum):
        if isFreeSpace(board, col):
            valid_locations.append(col)
    return valid_locations

def pick_best_move(board, piece):

    valid_locations = get_valid_locations(board)
    best_score = -10000
    best_col = random.choice(valid_locations)
    for col in valid_locations:
        row = get_next_open_row(board, col)
        temp_board = board.copy()
        reserveCell(temp_board, row, col, piece)
        score = score_position(temp_board, piece)
        if score > best_score:
            best_score = score
            best_col = col

    return best_col

def draw_board(board):
    for c in range(columnNum):
        for r in range(rowNum):
            pygame.draw.rect(screen, backGroundColor, (c*SQUARESIZE, r*SQUARESIZE+SQUARESIZE, SQUARESIZE, SQUARESIZE))
            pygame.draw.circle(screen, boardColor, (int(c*SQUARESIZE+SQUARESIZE/2), int(r*SQUARESIZE+SQUARESIZE+SQUARESIZE/2)), RADIUS)
    
    for c in range(columnNum):
        for r in range(rowNum):      
            if board[r][c] == PLAYER_PIECE:
                pygame.draw.circle(screen, firstPlayerColor, (int(c*SQUARESIZE+SQUARESIZE/2), height-int(r*SQUARESIZE+SQUARESIZE/2)), RADIUS)
            elif board[r][c] == AI_PIECE: 
                pygame.draw.circle(screen, secondPlayerColor, (int(c*SQUARESIZE+SQUARESIZE/2), height-int(r*SQUARESIZE+SQUARESIZE/2)), RADIUS)
    pygame.display.update()



#............................main............................................


pygame.init()

SQUARESIZE = 100
RADIUS = int(SQUARESIZE/2 - 5)
width = columnNum * SQUARESIZE
height = (rowNum+1) * SQUARESIZE
size = (width, height)
screen = pygame.display.set_mode(size)
def start_game():
    board = initializeBoard()
    printBoarder(board)
    game_over = False
    draw_board(board)
    pygame.display.update()

    myfont = pygame.font.SysFont("monospace", 75)

    turn = random.randint(PLAYER, AI)

    while not game_over:

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                sys.exit()

            if event.type == pygame.MOUSEMOTION:
                pygame.draw.rect(screen, boardColor, (0,0, width, SQUARESIZE))
                posx = event.pos[0]
                if turn == PLAYER:
                    pygame.draw.circle(screen, firstPlayerColor, (posx, int(SQUARESIZE/2)), RADIUS)

            pygame.display.update()

            if event.type == pygame.MOUSEBUTTONDOWN:
                pygame.draw.rect(screen, boardColor, (0,0, width, SQUARESIZE))
                #print(event.pos)
                # Ask for Player 1 Input
                if turn == PLAYER:
                    posx = event.pos[0]
                    col = int(math.floor(posx/SQUARESIZE))

                    if isFreeSpace(board, col):
                        row = get_next_open_row(board, col)
                        reserveCell(board, row, col, PLAYER_PIECE)

                        if isWinner(board, PLAYER_PIECE):
                            label = myfont.render("Player 1 wins!!", 1, RED)
                            screen.blit(label, (40,10))
                            game_over = True

                        turn += 1
                        turn = turn % 2

                        printBoarder(board)
                        draw_board(board)


        if turn == AI and not game_over:                

           
            col, minimaxWithPrunning_score = minimaxWithPrunning(board, 5, -math.inf, math.inf, True)

            if isFreeSpace(board, col):
                
                row = get_next_open_row(board, col)
                reserveCell(board, row, col, AI_PIECE)

                if isWinner(board, AI_PIECE):
                    label = myfont.render("Player 2 wins!!", 1, fontColor)
                    screen.blit(label, (40,10))
                    game_over = True

                printBoarder(board)
                draw_board(board)

                turn += 1
                turn = turn % 2

        if game_over:
            pygame.time.wait(3000)



def start_game2():

    board = initializeBoard()
    printBoarder(board)
    game_over = False
    turn = 0

    pygame.init()

    
    draw_board(board)
    pygame.display.update()

    myfont = pygame.font.SysFont("monospace", 75)

    while not game_over:

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                sys.exit()

            if event.type == pygame.MOUSEMOTION:
                pygame.draw.rect(screen, boardColor, (0,0, width, SQUARESIZE))
                posx = event.pos[0]
                if turn == 0:
                    pygame.draw.circle(screen, firstPlayerColor, (posx, int(SQUARESIZE/2)), RADIUS)
                else: 
                    pygame.draw.circle(screen, secondPlayerColor, (posx, int(SQUARESIZE/2)), RADIUS)
            pygame.display.update()

            if event.type == pygame.MOUSEBUTTONDOWN:
                pygame.draw.rect(screen, boardColor, (0,0, width, SQUARESIZE))
                #print(event.pos)
                # Ask for Player 1 Input
                if turn == 0:
                    posx = event.pos[0]
                    col = int(math.floor(posx/SQUARESIZE))

                    if isFreeSpace(board, col):
                        row = get_next_open_row(board, col)
                        reserveCell(board, row, col, 1)

                        if isWinner(board, 1):
                            label = myfont.render("Player 1 wins!!", 1, fontColor)
                            screen.blit(label, (40,10))
                            game_over = True


                # # Ask for Player 2 Input
                else:               
                    posx = event.pos[0]
                    col = int(math.floor(posx/SQUARESIZE))

                    if isFreeSpace(board, col):
                        row = get_next_open_row(board, col)
                        reserveCell(board, row, col, 2)

                        if isWinner(board, 2):
                            label = myfont.render("Player 2 wins!!", 1, fontColor)
                            screen.blit(label, (40,10))
                            game_over = True

                printBoarder(board)
                draw_board(board)

                turn += 1
                turn = turn % 2

                if game_over:
                    pygame.time.wait(3000)


os.environ['SDL_VIDEO_CENTERED'] = '1'

# Game Resolution
screen_width=800
screen_height=700
screen=pygame.display.set_mode((screen_width, screen_height))

# Text Renderer
def text_format(message, textFont, textSize, textColor):
    newFont=pygame.font.Font(textFont, textSize)
    newText=newFont.render(message, 0, textColor)

    return newText


# Colors
white=(255, 255, 255)
black=(0, 0, 0)
gray=(50, 50, 50)
red=(255, 0, 0)
green=(0, 255, 0)
blue=(0, 0, 255)
yellow=(255, 255, 0)

font = "Retro.ttf"


# Game Framerate
clock = pygame.time.Clock()
FPS=30

# Main Menu
def main_menu():

    menu=True
    selected="choice1"

    while menu:
        for event in pygame.event.get():
            if event.type==pygame.QUIT:
                pygame.quit()
                quit()
            if event.type==pygame.KEYDOWN:
                if event.key==pygame.K_UP:
                    selected="choice1"
                elif event.key==pygame.K_DOWN:
                    selected="choice2"
                if event.key==pygame.K_RETURN:
                    if selected=="choice2":
                        start_game()
                    if selected=="choice1":
                        start_game2()
                        

        
        screen.fill(gray)
        title=text_format("Connect 4", font, 90, yellow)
        if selected=="choice1":
            text_start=text_format("1 vs 1", font, 75, white)
        else:
            text_start = text_format("1 vs 1", font, 75, black)
        if selected=="choice2":
            text_quit=text_format("1 vs AI", font, 75, white)
        else:
            text_quit = text_format("1 vs AI", font, 75, black)

        title_rect=title.get_rect()
        start_rect=text_start.get_rect()
        quit_rect=text_quit.get_rect()

        
        screen.blit(title, (screen_width/2 - (title_rect[2]/2), 80))
        screen.blit(text_start, (screen_width/2 - (start_rect[2]/2), 300))
        screen.blit(text_quit, (screen_width/2 - (quit_rect[2]/2), 360))
        pygame.display.update()
        clock.tick(FPS)
        pygame.display.set_caption("Fcai ai project")

main_menu()
pygame.quit()
quit()
