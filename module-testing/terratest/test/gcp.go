package test

// Sets up GCP clients to be able to inspect created infrastructure

import (
	"context"

	"google.golang.org/api/compute/v1"
)

// Client to interact with GCP
var computeService *compute.Service

// Holds current error (if any occurred)
var err error

func initGCPClient() error {
	ctx := context.Background()
	computeService, err = compute.NewService(ctx)
	if err != nil {
		return err
	}

	return nil
}

func getInstance(projectID, zone, instanceName string) (*compute.Instance, error) {
	return computeService.Instances.Get(projectID, zone, instanceName).Do()
}
