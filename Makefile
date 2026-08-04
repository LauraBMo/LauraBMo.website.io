.PHONY: serve check clean

# Local preview at http://localhost:1313/, with live reload.
# Drafts and future-dated content are on via config/development/.
serve:
	hugo server

# The exact command CI runs, so a green check here means a green check there.
# --panicOnWarning turns a deprecation warning into a failed build: that is how
# the Hugo version pin in .env stays honest.
check:
	hugo --minify --gc --panicOnWarning

clean:
	rm -rf public resources .hugo_build.lock
