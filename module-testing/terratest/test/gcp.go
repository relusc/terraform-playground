package test

// Sets up GCP clients to be able to inspect created infrastructure

import (
	"context"
	"fmt"

	"google.golang.org/api/compute/v1"
	"google.golang.org/api/iam/v1"
)

// Client to interact with GCP GCE resources
var computeService *compute.Service

// Client to interact with GCP IAM resources
var iamService *iam.Service

// Holds current error (if any occurred)
var err error

// Initializes the Compute and IAM API clients
func initGCPClient() error {
	ctx := context.Background()
	computeService, err = compute.NewService(ctx)
	if err != nil {
		return err
	}

	iamService, err = iam.NewService(ctx)
	if err != nil {
		return err
	}

	return nil
}

// Gets a specific GCE instance
func getInstance(projectID, zone, instanceName string) (*compute.Instance, error) {
	return computeService.Instances.Get(projectID, zone, instanceName).Do()
}

// Gets a specific service account
func getServiceAccount(project, name string) (*iam.ServiceAccount, error) {
	return iamService.Projects.ServiceAccounts.Get(fmt.Sprintf("projects/%s/serviceAccounts/%s", project, name)).Do()
}
