# 3-Tier AWS Infrastructure (Terraform)

This stack provisions a 3-tier network and compute/database layout in AWS (`us-east-2`) using reusable Terraform modules.

## Simplified Architecture

```mermaid
flowchart LR
    Internet((Internet)) --> IGW[Internet Gateway]
    IGW --> ALB[Application Load Balancer\n(Public Web Subnets)]
    ALB --> ASG[Auto Scaling Group\nEC2 Web Instances]

    ASG --> AppTier[Private App Tier\n(Subnets + SG/NACL)]
    AppTier --> DBPrimary[(RDS MySQL Primary)]
    DBPrimary --> DBReplica[(RDS MySQL Read Replica)]

    NAT[NAT Gateways] --> AppTier
```

## Detailed Architecture

```mermaid
flowchart TB
        Internet((Internet)) --> IGW[Internet Gateway]

        subgraph AWS[Region us-east-2]
            subgraph VPC[VPC 10.0.0.0/16]
                IGW --> ALB[Application Load Balancer\nPublic in Web Subnets]

                subgraph WebTier[Web Tier - Public Subnets\n10.0.1.0/24, 10.0.2.0/24]
                    ALB --> TG[Target Group :80]
                    TG --> ASG[Auto Scaling Group\nEC2 Web Instances]
                    NAT1[NAT Gateway AZ-a]
                    NAT2[NAT Gateway AZ-b]
                end

                subgraph AppTier[App Tier - Private Subnets\n10.0.3.0/24, 10.0.4.0/24]
                    AppRT[Private Route Tables\nDefault route to NAT]
                    AppSG[App Security Group\nIngress 8080/22 from Web SG]
                end

                subgraph DBTier[DB Tier - Isolated Subnets\n10.0.5.0/24, 10.0.6.0/24]
                    DBSubnetGroup[RDS DB Subnet Group]
                    RDSPrimary[RDS MySQL Primary\nMulti-AZ]
                    RDSReplica[RDS MySQL Read Replica]
                    DBSG[DB Security Group\nMySQL 3306 from App SG]
                end

                WebRT[Public Route Table\n0.0.0.0/0 -> IGW] --> WebTier
                AppRT --> NAT1
                AppRT --> NAT2

                ASG -. outbound .-> NAT1
                ASG -. outbound .-> NAT2

                DBSubnetGroup --> RDSPrimary
                RDSPrimary --> RDSReplica
                DBSG --> RDSPrimary
                DBSG --> RDSReplica

                WebNACL[Web NACL]
                AppNACL[App NACL]
                DBNACL[DB NACL]

                WebNACL --- WebTier
                AppNACL --- AppTier
                DBNACL --- DBTier
            end
        end
```

## Current Terraform Modules

- `vpc-module`
- `subnet-module`
- `igw-module`
- `nat-gw-module`
- `routetable-module`
- `nacl-module`
- `security-group-module`
- `app-alb-module`
- `app-asg-module`
- `rds-module`

## Notes

- Web route table points to IGW for public ingress/egress.
- Private app routes use NAT gateways for outbound-only internet access.
- RDS instances run in DB subnets via DB subnet group and are not publicly accessible.
