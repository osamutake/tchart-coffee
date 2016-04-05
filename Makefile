BUNDLE := $(shell which bundle)

all:
ifndef BUNDLE
	gem install bundle
endif
	bundle install
	rake

