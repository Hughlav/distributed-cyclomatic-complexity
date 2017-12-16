# Distributed calculation of cyclomatic complexity of Haskell files

This is for TCD module CS4400 taught by Stephen Barrett. This project impliments a work stealing pattern for a manager and a set of nodes, to distribute the work of calculating the cyclomatic complexity of a haskell repository, using the Argon library. 

## How it works

The manager get the commit list for a repository. Upon statrup Workers clone the repository. The worker distributes shas corresponding to a particular committ as the workers ask for work. The worker sets the repository to the commit, uses argon the get the cyclomatic complexity of the files and then sums them and sends them back. The manager sums the complexity and returns the complexity along with the time taken to calculate the complexity.

For running locally call

```
stack exec use-cloudhaskell-exe worker localhost 8000
```

and 

```
stack exec use-cloudhaskell-exe manager localhost 8005 1
```

When workers are running on multiple nodes, they work fine. Locally due to the fact git repositories do not let multiple requests for changing the commit at the same time, it is not possible to run multiple workers.



![alt text](https://ibb.co/hkGNs6)

https://ibb.co/hkGNs6

I used aws to host the workers. The First data point at 1 was running locall, the second for one node on an aws server.
