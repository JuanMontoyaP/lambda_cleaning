.PHONY: build zip

clean:
	rm -rf src/packages lambda_function.zip src/requirements.txt

build:
	cd src && \
	uv export --frozen --no-dev --no-editable -o requirements.txt  && \
	uv pip install \
   		--no-installer-metadata \
   		--no-compile-bytecode \
   		--python-platform x86_64-manylinux2014 \
   		--python 3.13 \
   		--target packages \
   		-r requirements.txt

zip: build
	cd src && \
	zip -qr ../lambda_function.zip packages && \
	zip -q ../lambda_function.zip main.py

deploy: clean zip
	cd terraform && \
	terraform init && \
	terraform apply -auto-approve
