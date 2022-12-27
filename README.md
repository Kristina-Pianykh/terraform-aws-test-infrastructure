### To test the autoscaling

- connect to an EC2 instance via AWS Console
- Install the stress testers with:

```bash
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
```

- Run the stress tester with:

```bash
stress -c <cpu_cores>
```
