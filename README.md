# aws-website-infra
Cloudformation templates for web hosting infrastructure using S3, CloudFront, ACM, and CodeCommit. I set these templates up to roll out infrastructure to support really cheap static sites on AWS.

## Prerequisites

If you want the static-site-stack to create Route53 records, you need to have the domain configured. Pass the ZoneId during deployment and it'll create them. I'm using external DNS for my personal website, so I made that part conditional. Another thing you'll need is the Build Job. I plan on making this conditional in the future, but I ran out of time.

#### Table of Contents
* [cert-stack.yml](#cert-stack)
  * [ACM](#ACM)
* [static-site-stack.yml](#static-site-stack)
  * [S3](#S3)
  * [CloudFront](#CloudFront)
  * [Route53](#Route53)
* [repo-stack.yml](#repo-stack)
  * [CodeCommit](#CodeCommit)
* [External Resources](#external)
  * [BuildJob](#BuildJob)
* [Deployment](#deployment)
  * [Parameters](#parameters)

## cert-stack

This stack holds the ACM cert for CloudFront.

### ACM <a name="ACM" />

Provides free SSL certificates.

## static-site-stack

The core of the hosting stacks.

### S3 <a name="S3" />

S3 is the hosting platform for the static pages. It's simultaneously scalable and inexpensive. There's also a second bucket for S3 and CloudFront logs.

### CloudFront <a name="CloudFront" />

CloudFront provides SSL termination. If you don't want https, this part is unnecessary for the hosting. The benefits are debatable. Important point in this config is that I'm using S3's WebsiteURL instead of the DomainName. This makes the directory reference function properly.

### Route53 <a name="Route53" />

Conditionally creates alias records for the CloudFront endpoint.

## repo-stack

This stack contains the CodeCommit repo for the code and trigger for the build job. I think in the future, I'll make the trigger conditional so that it doesn't require the build job stack to exist before you can deploy the repo. A quick `update-stack` command after the build job exists should be enough to add the trigger.

### CodeCommit <a name="CodeCommit" />

I went with CodeCommit because it's a free, private repo for small projects. GitHub is a much better choice for large, mature projects, but I wanted to understand CodeCommit's limitations, which are many. The trigger has a custom data property that tells the deploy job which bucket to push to.

## External Resources <a name="external" />

These resources exist outside the infrastructure stacks.

### BuildJob <a name="BuildJob" />

I set up a lambda, written in python, that builds the static site and pushes it to S3. My static sites are developed with [Hugo](gohugo.io), so the Hugo binary is bundled into the lambda package. This lambda is deployed as a separate stack because it's project agnostic. I have many static sites to host in this account, so I made the lambda universal. Not all static websites will use this same build process, so I'm leaving it flexible.

## Deployment

To deploy these resources, I've supplied a Makefile to deploy the stacks. I didn't put in the effort to make these create/update automatically, so if you need to update a stack, you'll need to modify the cli command to `update-stack`.

### Parameters <a name="parameters" />

The deploy jobs take a few parameters to fill in the stacks.

* RootDomainName - The domain name of the project.
* ProjectShortName - A short name that helps label all the stacks and resources.
* ZoneId - Optional, Include if you want the stacks to deploy DNS aliases for CloudFront.
