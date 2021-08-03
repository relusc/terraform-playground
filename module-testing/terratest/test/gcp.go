package test

// Sets up GCP clients to be able to inspect created infrastructure

import (
	"context"

	"google.golang.org/api/compute/v1"
)

// Client to interact with GCP GCE resources
var computeService *compute.Service

// Holds current error (if any occurred)
var err error

// Initializes the Compute and IAM API clients
func initGCPClient() error {
	ctx := context.Background()
	computeService, err = compute.NewService(ctx)
	if err != nil {
		return err
	}

	return nil
}

// Gets a specific GCE instance
func getInstance(projectID, zone, instanceName string) (*compute.Instance, error) {
	return computeService.Instances.Get(projectID, zone, instanceName).Do()
}
