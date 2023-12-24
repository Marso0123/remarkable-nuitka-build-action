class HelloWorldException(Exception):
    pass


def talk(message):
    return "Talk " + message


def main():
    raise HelloWorldException(talk("Hello World"))


if __name__ == "__main__":
    main()
