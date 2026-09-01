.PHONY: all validate lint test clean

TEMPLATES := $(wildcard iam-password-policy/*.yaml)

all: validate lint

validate:
	@echo "Validating CloudFormation templates..."
	@which cfn-lint > /dev/null 2>&1 && cfn-lint $(TEMPLATES) || echo "cfn-lint not installed (run: pip install cfn-lint)"
	@which aws > /dev/null 2>&1 && echo "AWS CLI installed." || echo "AWS CLI not found."

lint:
	@echo "Linting YAML templates..."
	@which yamllint > /dev/null 2>&1 && yamllint $(TEMPLATES) || echo "yamllint not installed (run: pip install yamllint)"

test: validate lint

clean:
	@echo "Cleaning temporary files..."
	@rm -rf .tmp/ .pytest_cache/ __pycache__/ *.packaged.yaml
