# LightOperations
Super light framework based on Operations, it eases the creation of inter-dependent operations in OperationQueues.

Eliminates the need of boiler plate code when creating asynchronous operations (Operation), by providing a ready-to-sublcass LightOperation. 

A Coupler class can make your life easy when using OperationQueues. The Coupler class allows to pass the result of the first operation, transform it (optionally) and pass it as input data of the next operation.
It will also set the correct dependencies between the operations.

You can see this framework in action in my project GeoApp.

Notes and tests coming soon. 
