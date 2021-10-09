import subprocess

class Terraform():
    def __init__(self):
        pass

    def init(self):
        process = subprocess.Popen(["./terraform", "init"])

        print(process)

    def plan(self, var_file=None):
        plan_step = ["./terraform", "plan"]

        plan_step = plan_step+[f"-var-file={var_file}"] if var_file else plan_step

        process = subprocess.Popen(plan_step)

        print(process)

if __name__ == "__main__":
    print("asdf")