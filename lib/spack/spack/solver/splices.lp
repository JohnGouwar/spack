% Copyright 2013-2024 Lawrence Livermore National Security, LLC and other
% Spack Project Developers. See the top-level COPYRIGHT file for details.
%
% SPDX-License-Identifier: (Apache-2.0 OR MIT)

%=============================================================================
% These rules are conditionally loaded to handle the synthesis of spliced
% packages.
% =============================================================================

% Rules that derive abi_splice_conditions_hold will be generated from packages'
% use of the `can_splice` directive. The will have the following form:
% can_splice("foo@1.0.0+a", when=@1.0.1+a", match_variants=["b"]) --->
% abi_splice_conditions_hold(0, node(SID, "foo"), "foo", BashHash) :-
%   installed_hash("foo", BaseHash),
%   attr("node", node(SID, SpliceName)),
%   attr("node_version_satisfies", node(SID, "foo"), "1.0.1"),
%   hash_attr("hash", "node_version_satisfies", "foo", "1.0.1"),
%   attr("variant_value", node(SID, "foo"), "a", "True"),
%   hash_attr("hash", "variant_value", "foo", "a", "True"),
%   attr("variant_value", node(SID, "foo"), "b", VariVar0),
%   hash_attr("hash", "variant_value", "foo", "a", VariVar0),

% If the splice is valid (i.e. abi_splice_conditions_hold is derived) in the
% dependency of a concrete spec the solver free to choose whether to continue
% with the exact hash semantics by simply imposing the child hash, or introducing
% a spliced node as the dependency instead 
1 {
  imposed_constraint(ParentHash, "hash", ChildName, ChildHash);
  attr("splice_hash", node(SID, SpliceName), ChildName, ChildHash, node(ID, PackageName))   
} 1 :-
  attr("hash", node(ID, PackageName), ParentHash),
  hash_attr(ParentHash, "hash", ChildName, ChildHash),
  abi_splice_conditions_hold(_, node(SID, SpliceName), ChildName, ChildHash).
  
% Names and virtual providers may change when a dependency is spliced in
imposed_constraint(Hash, "dependency_holds", PackageName, SpliceName, Type) :-
  hash_attr(Hash, "depends_on", PackageName, DepName, Type),
  hash_attr(Hash, "hash", DepName, DepHash),
  attr("splice_hash", node(SID, SpliceName), DepName, DepHash, node(ID, PackageName)).
  
imposed_constraint(Hash, "virtual_on_edge", PackageName, SpliceName, VirtName) :-
  hash_attr(Hash, "virtual_on_edge", PackageName, DepName, VirtName),
  attr("splice_hash", node(SID, SpliceName), DepName, _, _).


