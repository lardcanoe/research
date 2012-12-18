import bottle
import os

@bottle.get('/index')
def index():
    return "Hello there!"

@bottle.get('/test')
def index():
    return "This is a test."

if __name__ == '__main__':
    bottle.debug(True)
    bottle.run(reloader=True, port=8080)
else:
    os.chdir(os.path.dirname(__file__))
    application = bottle.default_app()