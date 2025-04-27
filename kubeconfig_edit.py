import sys
import yaml
import os

def main():
    # Check that environment variables have been properly set
    address = os.environ.get('ADDRESS')
    config_name = os.environ.get('CONFIG_NAME')
    env_errors = []
    if not address:
        env_errors.append("Environment variable 'ADDRESS' is not set.")
    if not config_name:
        env_errors.append("Environment variable 'CONFIG_NAME' is not set.")
    if len(env_errors) > 0:
        print("\n".join(env_errors), file=sys.stderr)
        sys.exit(1)

    # Read YAML data from stdin
    try:
        data = yaml.safe_load(sys.stdin)
    except yaml.YAMLError as exc:
        print(f"Error parsing YAML input: {exc}", file=sys.stderr)
        sys.exit(1)

    # Update the KUBECONFIG fields to ensure they are unique
    for cluster_entry in data['clusters']:
        cluster_entry['cluster']['server'] = f'https://{address}:6443'
        cluster_entry['name'] = config_name

    for context_entry in data['contexts']:
        context_entry['context']['cluster'] = config_name
        context_entry['context']['user'] = config_name + '_user'
        context_entry['name'] = config_name

    data['current-context'] = config_name

    for user_entry in data['users']:
        user_entry['name'] = config_name + '_user'

    # Write updated YAML to stdout
    try:
        yaml.dump(data, sys.stdout, default_flow_style=False)
    except yaml.YAMLError as exc:
        print(f"Error writing YAML output: {exc}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
