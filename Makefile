VERSION = 1.0.0-r1
IMAGE = htplbc/dr-toolkit:$(VERSION)

all:

image:
	docker build -t $(IMAGE) --no-cache .

publish:
	docker push $(IMAGE)