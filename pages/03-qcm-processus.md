---

# Module 6 MCQ: Processes and services ✅

**10 questions on process management and systemd**

---

# Question 1

What is the PID of the first system process?

A) 0

B) 1

C) 10

D) 100

---

# Question 2

Which command shows processes in real time?

A) `ps`

B) `top`

C) `pgrep`

D) `htop`

---

# Question 3

What signal does `kill` send by default?

A) SIGKILL (9)

B) SIGTERM (15)

C) SIGHUP (1)

D) SIGINT (2)

---

# Question 4

How do you start a service with systemd?

A) `systemctl start service`

B) `service start`

C) `start service`

D) `systemd start service`

---

# Question 5

What is the difference between `start` and `enable`?

A) None

B) `start` starts now, `enable` at boot

C) `enable` starts now, `start` at boot

D) They do the same thing

---

# Question 6

Where do you view logs for a systemd service?

A) `/var/log/service.log`

B) `journalctl -u service`

C) `systemctl logs service`

D) `dmesg`

---

# Question 7

How do you change a process’s priority?

A) `priority`

B) `nice` or `renice`

C) `top`

D) `ps`

---

# Question 8

What does `Ctrl+Z` do?

A) Kills the process

B) Suspends the process

C) Exits the program

D) Restarts the process

---

# Question 9

How do you list services that have failed?

A) `systemctl failed`

B) `systemctl --failed`

C) `systemctl list-failed`

D) `journalctl --failed`

---

# Question 10

What is a zombie process?

A) A process that uses a lot of CPU

B) A process that has exited but was not reaped by its parent

C) A malicious process

D) A process without a PID

---

# Module 6 answers 📝

**Answer 1:** B) 1
- PID 1 is `systemd` (or `init` on older systems)

**Answer 2:** B) `top` (or D `htop`)
- Both show processes in real time; `htop` is more modern

**Answer 3:** B) SIGTERM (15)
- SIGTERM lets the process exit cleanly

**Answer 4:** A) `systemctl start service`
- systemd uses the `systemctl` command

**Answer 5:** B) `start` starts now, `enable` at boot
- `enable` configures automatic startup

---

# Module 6 answers (continued) 📝

**Answer 6:** B) `journalctl -u service`
- journalctl is systemd’s logging tool

**Answer 7:** B) `nice` or `renice`
- `nice` at launch, `renice` for an existing process

**Answer 8:** B) Suspends the process
- The process goes to the background suspended. Use `fg` to resume

**Answer 9:** B) `systemctl --failed`
- Lists all services in the "failed" state

**Answer 10:** B) A process that has exited but was not reaped by the parent
- It stays in the process table until the parent reads its exit status

---

# Module 6 score 📊

Count your correct answers:

- **9–10:** Excellent! ⭐⭐⭐
- **7–8:** Good! ⭐⭐
- **5–6:** Needs review ⭐
- **< 5:** Reread module 6
