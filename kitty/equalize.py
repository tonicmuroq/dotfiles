"""Kitten to equalize window sizes along a given axis in the splits layout."""


def main(args):
    pass


from kittens.tui.handler import result_handler


def count_leaves(node, axis):
    """Count units this node occupies on the given axis."""
    if not hasattr(node, 'one'):
        return 1
    if node.horizontal == axis:
        # Same axis: children contribute separately
        return count_leaves(node.one, axis) + count_leaves(node.two, axis)
    else:
        # Different axis: whole subtree is one unit on this axis
        return 1


def equalize(node, axis):
    """Equalize all splits along the given axis."""
    if not hasattr(node, 'one'):
        return
    if node.horizontal == axis:
        left = count_leaves(node.one, axis)
        right = count_leaves(node.two, axis)
        node.bias = left / (left + right)
    equalize(node.one, axis)
    equalize(node.two, axis)


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if tab is None:
        return
    layout = tab.current_layout
    root = getattr(layout, 'pairs_root', None)
    if root is None:
        return
    # 'h' for hsplit, 'v' for vsplit, default: both axes
    if len(args) > 1 and args[1] in ('h', 'v'):
        equalize(root, args[1] == 'v')
    else:
        equalize(root, True)
        equalize(root, False)
    tab.relayout()
