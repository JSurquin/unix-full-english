---

# Quiz Module 8: Automation and scripts ✅

**10 questions on scripting and scheduled tasks**

---

# Question 1

What is the first line of a bash script?

A) `#bash`

B) `#!/bin/bash`

C) `<bash>`

D) `//bin/bash`

---

# Question 2

How do you make a script executable?

A) `chmod +x script.sh`

B) `execute script.sh`

C) `make executable script.sh`

D) `run script.sh`

---

# Question 3

How do you define a variable in bash?

A) `var = value`

B) `var=value`

C) `set var value`

D) `$var=value`

---

# Question 4

How do you access a variable's value?

A) `var`

B) `$var`

C) `&var`

D) `@var`

---

# Question 5

Which command schedules recurring tasks?

A) `at`

B) `cron`

C) `timer`

D) `schedule`

---

# Question 6

What does `0 2 * * *` mean in a crontab?

A) Every 2 minutes

B) At 2:00 AM every day

C) Every 2 days

D) On the 2nd of each month

---

# Question 7

How do you view systemd logs in real time?

A) `tail -f /var/log/syslog`

B) `journalctl -f`

C) `logwatch`

D) `logs -f`

---

# Question 8

Which construct creates a loop in bash?

A) `loop ... end`

B) `for ... done`

C) `while ... endwhile`

D) `repeat ... until`

---

# Question 9

How do you redirect both stdout and stderr to a file?

A) `command > file`

B) `command 2> file`

C) `command &> file`

D) `command >> file`

---

# Question 10

Which command schedules a one-off task?

A) `cron`

B) `at`

C) `once`

D) `schedule`

---

# Module 8 answers 📝

**Answer 1:** B) `#!/bin/bash`
- The shebang tells the system which interpreter to use

**Answer 2:** A) `chmod +x script.sh`
- Then run it with `./script.sh`

**Answer 3:** B) `var=value`
- ⚠️ No spaces around `=`!

**Answer 4:** B) `$var`
- Or `${var}` (recommended form)

**Answer 5:** B) `cron`
- `crontab -e` to edit cron jobs

---

# Module 8 answers (continued) 📝

**Answer 6:** B) At 2:00 AM every day
- Format: minute hour day month weekday

**Answer 7:** B) `journalctl -f`
- `-f` = follow (like `tail -f`)

**Answer 8:** B) `for ... done`
- Example: `for i in {1..5}; do echo $i; done`

**Answer 9:** C) `command &> file`
- Or `command > file 2>&1`

**Answer 10:** B) `at`
- `at now + 1 hour` for one hour from now

---

# Module 8 score 📊

Count your correct answers:

- **9-10**: Excellent! ⭐⭐⭐
- **7-8**: Good! ⭐⭐
- **5-6**: Needs review ⭐
- **< 5**: Reread module 8
