---
layout: new-section
routeAlias: 'ansible-introduction'
---

<a name="ansible-introduction" id="ansible-introduction"></a>

# 🤖 Ansible - agentless automation
## Day 3 afternoon (pivot from shell craft to fleet operations)

**Ansible** pushes **declarative plays** over **SSH** (or APIs) without installing a permanent agent on Linux targets.

---

# Architectural mental model

```text
Control node (ansible-core)
        │  YAML playbooks
        │  Inventory (INI/YAML)
        ▼
Managed hosts :22 (OpenSSH + python+)
```

**No agent** → bootstrap is cheap.  
Trade-off: needs **clean SSH keys**, **sudo policy**, and **Python** on targets (or `raw` bootstrap first).

---

# Idempotence - why it matters

Each module compares **desired state** vs **observed state**:

- Package present/absent  
- File content / permissions  
- Service enabled + running  

Running the playbook **twice** should be safe - if everything drifts, the second run **repairs** drift.

---

# Compared to Chef / Puppet / Salt

| Tool | Strength | Typical friction |
|------|----------|------------------|
| **Ansible** | Fast start, YAML ergonomics, agentless | Large scale fact caching / performance tuning |
| **Puppet** | Strong CMDB / enforcement model | Agent overhead, DSL learning curve |
| **Chef** | Test-driven cookbooks, Ruby ecosystem | Heavier operations stack |
| **Salt** | Event bus + reactive states | Master/minion design complexity |

Choose based on **team skills**, **compliance**, **scale**, not hype.

---

# Core vocabulary

| Concept | Role |
|---------|------|
| **Inventory** | Host groups + connection vars |
| **Play** | Ordered tasks applied to a group |
| **Task** | Single module invocation |
| **Handler** | Notified restart on change |
| **Role** | Reusable bundle (tasks, vars, templates) |

---

# Inventory snippet

```ini
[web]
web01 ansible_host=10.0.10.11

[db]
db01 ansible_host=10.0.10.21

[lab:children]
web
db

[lab:vars]
ansible_user=sysadmin
ansible_ssh_private_key_file=~/.ssh/lab_ed25519
```

---

# Playbook skeleton

```yaml
- name: Baseline sudo + monitoring agent
  hosts: lab
  become: true
  vars:
    snmp_ro_community: "teach-ro"
  tasks:
    - name: Ensure snmpd is installed
      ansible.builtin.package:
        name: net-snmp
        state: present

    - name: Push snmpd template
      ansible.builtin.template:
        src: templates/snmpd.conf.j2
        dest: /etc/snmp/snmpd.conf
      notify: Restart snmpd

  handlers:
    - name: Restart snmpd
      ansible.builtin.service:
        name: snmpd
        state: restarted
```

---

# Variables & precedence (practical subset)

1. **Extra vars** (`-e`) win in emergencies.  
2. **Host vars** / **group vars** for environment differences.  
3. **Role defaults** for reusable baselines.  

Keep secrets in **Ansible Vault**, not Git plaintext.

---

# Facts

`ansible_facts` (gathered at play start) expose:

- `ansible_distribution` / `version`  
- Network interfaces & default gateway  
- Mounts, CPUs, memory  

Use facts to branch tasks (`when:`) without hardcoding hostnames everywhere.

---

# Recommended Day-3 exercises

1. Bootstrap inventory from **three lab VMs**.  
2. Playbook ensures **LDAP client packages + snmpd** baseline.  
3. Students **encrypt** a secret with `ansible-vault` and load it in `group_vars`.  
4. **Idempotence drill:** run playbook twice, observe `changed=0`.
