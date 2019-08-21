from dnd_char_gen.utils import roll, choose

ABILITY_MATRIX = {
    "1": {
        "1": [15, 15, 15, 8, 8, 8],
        "2": [15, 15, 14, 10, 8, 8],
        "3": [15, 15, 14, 9, 9, 8],
        "4": [15, 15, 13, 12, 8, 8],
        "5": [15, 15, 13, 11, 9, 8],
        "6": [15, 15, 13, 10, 10, 8],
        "7": [15, 15, 13, 10, 9, 9],
        "8": [15, 15, 12, 12, 9, 8],
        "9": [15, 15, 12, 11, 10, 8],
        "10": [15, 15, 12, 11, 9, 9]
    },
    "2": {
        "1": [15, 15, 12, 10, 10, 9],
        "2": [15, 15, 11, 11, 11, 8],
        "3": [15, 15, 11, 11, 10, 9],
        "4": [15, 15, 11, 10, 10, 10],
        "5": [15, 14, 14, 12, 8, 8],
        "6": [15, 14, 14, 11, 9, 8],
        "7": [15, 14, 14, 10, 10, 8],
        "8": [15, 14, 14, 10, 9, 9],
        "9": [15, 14, 13, 13, 9, 8],
        "10": [15, 14, 13, 12, 10, 8]
    },
    "3": {
        "1": [15, 14, 13, 12, 9, 9],
        "2": [15, 14, 13, 11, 11, 8],
        "3": [15, 14, 13, 11, 10, 9],
        "4": [15, 14, 13, 10, 10, 10],
        "5": [15, 14, 12, 12, 11, 8],
        "6": [15, 14, 12, 12, 10, 9],
        "7": [15, 14, 12, 11, 11, 9],
        "8": [15, 14, 12, 11, 10, 10],
        "9": [15, 14, 11, 11, 11, 10],
        "10": [15, 13, 13, 13, 11, 8]
    },
    "4": {
        "1": [15, 13, 13, 13, 10, 9],
        "2": [15, 13, 13, 12, 12, 8],
        "3": [15, 13, 13, 12, 11, 9],
        "4": [15, 13, 13, 12, 10, 10],
        "5": [15, 13, 13, 11, 11, 10],
        "6": [15, 13, 12, 12, 12, 9],
        "7": [15, 13, 12, 12, 11, 10],
        "8": [15, 13, 12, 11, 11, 11],
        "9": [15, 12, 12, 12, 12, 10],
        "10": [15, 12, 12, 12, 11, 11]
    }
}


def roll_ability():
    ABILITIES = {
        'STR': 8,
        'DEX': 8,
        'CON': 8,
        'INT': 8,
        'WIS': 8,
        'CHA': 8
    }
    r4 = str(roll(4))
    r10 = str(roll(10))
    selection = ABILITY_MATRIX[r4][r10]
    order = choose(list(ABILITIES), len(ABILITIES))
    pairing = zip(order, selection)

    for abl, num in pairing:
        ABILITIES[abl] = num

    # print(f'R4: {r4}')
    # print(f'R10: {r10}')
    # print(f'selection: {selection}')
    # print(f'order: {order}')
    # print(f'matrix: {ABILITIES}')
    return ABILITIES


if __name__ == '__main__':
    roll_ability()
