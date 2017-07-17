cert:
	aws --profile default --region us-east-1 cloudformation create-stack \
		--stack-name 'XYZCert' --parameters ParameterKey=RootDomainName,ParameterValue=XYZ.com \
				ParameterKey=ProjectShortName,ParameterValue=XYZ \
				--template-body file://cert-stack.yml
site:
	aws --profile default --region us-east-1 cloudformation create-stack \
		--stack-name 'XYZStaticSite' --parameters ParameterKey=RootDomainName,ParameterValue=XYZ.com \
				ParameterKey=ZoneId,ParameterValue='' ParameterKey=ProjectShortName,ParameterValue=XYZ \
				--template-body file://static-site-stack.yml
repo:
	aws --profile default --region us-east-1 cloudformation create-stack \
		--stack-name 'XYZRepo' --parameters ParameterKey=ProjectShortName,ParameterValue=XYZ \
				--template-body file://repo-stack.yml
